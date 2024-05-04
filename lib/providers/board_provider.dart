import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../tools/logging.dart';
import '../tools/utils.dart';
import '../tools/board_items_sort_by.dart';
import '../models/board_item.dart';
import '../models/category.dart';
import '../models/dwell_menu_item.dart';
import 'user_provider.dart';

class BoardProvider extends ChangeNotifier {
  late User _user;
  List<BoardItem>? boardItems;
  List<DwellCategory>? _categories;
  String? selectedItem;
  DateTime? _lastFetched;
  SortBy _by = SortBy();
  List<DwellMenuItem> options = [
    DwellMenuItem(
      name: "Uusimmat",
      sortBy: SortBy.created,
      selected: true,
    ),
    DwellMenuItem(
      name: "Suosituimmat",
      sortBy: SortBy.upvotes,
      selected: false,
    ),
  ];

  set by(DwellMenuItem item) {
    _by.selected = item.sortBy;

    if (boardItems == null)
      throw Exception("BoardItems can't be null when sorting");

    item.sortBy == SortBy.created
        ? boardItems!.sort((a, b) =>
            b.created.millisecondsSinceEpoch - a.created.millisecondsSinceEpoch)
        : boardItems!.sort((a, b) => b.numOfUpvotes - a.numOfUpvotes);

    options.forEach((e) => e.selected = e.sortBy == _by.selected);

    notifyListeners();
    Log.success(_by.selected);
  }

  set selectedFromOutside(String id) {
    selectedItem = id;
    notifyListeners();
  }

  void update(User user) {
    _user = user;
  }

  void clearBoardProvider() {
    selectedItem = null;
    boardItems = null;
    _categories = null;
    _lastFetched = null;
  }

  Future<void> fetchAllCategories() async {
    if (_categories != null) return;
    try {
      Map<String, dynamic>? res = await _user.apiGet(endpoint: 'category');
      _categories = res['categories']
          .map<DwellCategory>(
              (c) => DwellCategory(id: c['_id'], name: c['name']))
          .toList();
    } catch (e) {
      Log.error("fetchAllCategories", e);
    }
  }

  Future<void> sendMessage(
    String submitText, {
    bool adminNotifyAllUsers = false,
  }) async {
    try {
      if (submitText.length < 2) {
        _user.notification(errorMessage: 'Viesti on liian lyhyt');
        return;
      }
      _addNewBoardItem(text: submitText);

      String? c = _categories?.first.id;

      if (c == null)
        throw Exception("Category can't be null while sending a message");

      var res = await _user.apiPost(
        endpoint: 'category/$c/messages',
        data: {
          'title': submitText,
          'body': submitText,
          'response_to': selectedItem,
          'admin_notify_all_users': adminNotifyAllUsers
        },
      );

      if (res['message'] == null) throw Exception("Response was null");

      if (_user.id == null) throw Exception("user id can't be null");

      _removeOptimisticallyAddedBoardItem();

      Log.info(res['message']);
      _addNewBoardItem(
          item: BoardItem.fromJson(res['message'])..userId = (_user.id)!,
          text: submitText);
      notifyListeners();
    } catch (e) {
      Log.error("error sending a message", e);
      _removeOptimisticallyAddedBoardItem();
      rethrow;
    }
  }

  void _addNewBoardItem({BoardItem? item, required String text}) {
    String? c = _categories?.first.id;

    if (c == null)
      throw Exception(
          "Category can't be null in _addNewBoardItem() while sending a message");
    if (_user.id == null) throw Exception("user id can't be null");
    if (selectedItem != null) {
      boardItems?.forEach((element) {
        if (element.id == selectedItem) {
          element.children.add(item ??
              BoardItem.createNew(
                  text, c, selectedItem!, (_user.id)!, _user.role));
        }
      });
    } else {
      boardItems?.insert(
          0,
          item ??
              BoardItem.createNew(
                  text, c, selectedItem, (_user.id)!, _user.role));
    }
  }

  void _removeOptimisticallyAddedBoardItem() {
    if (selectedItem != null) {
      boardItems?.forEach((element) {
        if (element.id == selectedItem) {
          element.children.removeWhere((element) => element.waitingResponse);
        }
      });
    } else {
      boardItems?.removeWhere((element) => element.waitingResponse);
    }
  }

  static Future<List<BoardItem>> _parseItems(ComputableBoard b) async {
    List<BoardItem> listInIsolate = b.all.map<BoardItem>((e) {
      BoardItem item = BoardItem.fromJson(e);
      item..userId = b.uid;
      return item;
    }).toList();

    List<BoardItem> boardItemsInIsolate =
        listInIsolate.where((e) => e.responseTo == null).toList();

    boardItemsInIsolate.forEach((element) {
      List<BoardItem> list =
          listInIsolate.where((e) => e.responseTo == element.id).toList();
      list.sort((a, b) =>
          a.created.millisecondsSinceEpoch - b.created.millisecondsSinceEpoch);

      element.children.addAll(list);
    });

    return boardItemsInIsolate;
  }

  bool _testLastFetched() =>
      _lastFetched != null &&
      _lastFetched!.isAfter(DateTime.now().subtract(Duration(seconds: 60))) &&
      boardItems != null;

  void toggleUpvote(BoardItem boardItem) {
    boardItem.toggleUpvote();

    if (!boardItem.waitingResponse)
      _user.apiPatch(endpoint: 'message/${boardItem.id}/upvote').then((res) {
        if (boardItem.numOfUpvotes != res['message']['num_of_upvotes']) {
          boardItem.numOfUpvotes = res['message']['num_of_upvotes'];
        }
      }).catchError((err) {
        Log.error("Error in upvoting messages", err);
        boardItem.toggleUpvote();
      });

    notifyListeners();
  }

  void toggleInappropriate(BoardItem boardItem) {
    if (boardItem.votedInappropriateBy == null)
      boardItem.votedInappropriateBy = [_user.id].toList();
    else if (boardItem.votedInappropriateBy!.contains(_user.id)) {
      boardItem.votedInappropriateBy!.remove(_user.id);
    } else
      boardItem.votedInappropriateBy!.add(_user.id);

    _user
        .apiPatch(endpoint: 'message/${boardItem.id}/inappropriate')
        .then((res) {
      Log.success(
          "boardItem.votedInappropriateBy",
          boardItem.votedInappropriateBy,
          res['message']['voted_inappropriate_by']);
    }).catchError((err) {
      Log.error("Error in toggleInappropriate", err);
    });

    notifyListeners();
  }

  void removeBoardItem(BoardItem boardItem) {
    if (!boardItem.parent && selectedItem != null) {
      boardItems?.forEach((element) {
        if (element.id == selectedItem) {
          element.children.removeWhere((element) => element.id == boardItem.id);
        }
      });
    } else {
      boardItems?.removeWhere((element) => element.id == boardItem.id);
      selectedItem = null;
    }

    if (!boardItem.waitingResponse) {
      _user.apiPatch(endpoint: 'message/${boardItem.id}').then((res) {
        Log.success("Deleted ", boardItem.body);
      }).catchError((err) {
        Log.error("Error deleteting messages", err);
      });
    } else {
      Log.error("waiting response", boardItem.id);
    }
    notifyListeners();
  }

  Future<List<BoardItem>> fetchBoardItems([force = false]) async {
    try {
      if (_testLastFetched() && !force) return boardItems!;
      _lastFetched = DateTime.now();
      await fetchAllCategories();

      var res = await _user.apiGet(
        endpoint: Utils.queryParams(
          endpoint: 'message',
          params: {'sort': _by.selected, 'dir': 'desc'},
        ),
      );

      if (res['messages'] == null) throw Exception("No messages in response");
      if (_user.id == null) throw Exception("user id can't be null");

      boardItems = await compute(
        _parseItems,
        ComputableBoard(res['messages'] as List, (_user.id)!),
      );

      _by.selected == SortBy.created
          ? boardItems?.sort((a, b) =>
              b.created.millisecondsSinceEpoch -
              a.created.millisecondsSinceEpoch)
          : boardItems?.sort((a, b) => b.numOfUpvotes - a.numOfUpvotes);

      if (force) notifyListeners();
      return boardItems!;
    } catch (e) {
      Log.error("FetchBoardItem", e);
      rethrow;
    }
  }
}

class ComputableBoard {
  final List all;
  final String uid;

  ComputableBoard(this.all, this.uid);
}
/* {
      "_id": "5f84189943f1f16afafcd3f0",
      "body": "555555656",
      "category": "5eb2ab0b3e2e7e713d679ed0",
      "commentsDisabled": false,
      "created": 1602492569,
      "num_of_inappropriate_flags": 0,
      "num_of_upvotes": 3,
      "public": true,
      "read_by": [],
      "recipients": [],
      "removed": false,
      "response_to": null,
      "sender": "5e5654671370300957db3092",
      "title": "555555656",
      "upvoted_by": [
        "5eaa7f67153ec1d62226fde9",
        "5ebd390526e27fb5289b1ad6",
        "5f72ee04173bbce290d7724f"
      ]
    },
    {
      "_id": "5f84212b43f1f16afafd1735",
      "body": "6777",
      "category": "5eb2ab0b3e2e7e713d679ed0",
      "commentsDisabled": false,
      "created": 1602494763,
      "num_of_inappropriate_flags": 0,
      "num_of_upvotes": 1,
      "public": true,
      "read_by": [],
      "recipients": [],
      "removed": false,
      "response_to": "5f840d674e27000d5a76ab59",
      "sender": "5e5654671370300957db3092",
      "title": "6777",
      "upvoted_by": [
        "5eaa7f67153ec1d62226fde9"
      ]
    }, */
