import 'package:hive/hive.dart';
part 'board_item.g.dart';

@HiveType(typeId: 4)
class BoardItem {
  @HiveField(0)
  final DateTime created;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String body;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String? responseTo;
  @HiveField(5) // if null, board item is parent
  final String sender;
  @HiveField(6)
  final String title;
  @HiveField(7)
  final int numOfInappropriateFlags;
  @HiveField(8)
  int numOfUpvotes;
  @HiveField(9)
  final bool commentsDisabled;
  @HiveField(10)
  final bool removed;
  @HiveField(11)
  final bool public;
  @HiveField(12)
  final List readBy;
  @HiveField(13)
  final List recipients;
  @HiveField(14)
  final List upvotedBy;
  @HiveField(15)
  List<BoardItem> children = [];
  @HiveField(16)
  List? votedInappropriateBy;
  @HiveField(17)
  String? senderRole;

  bool waitingResponse = false;
  String? userId;

  bool get parent {
    return responseTo == null;
  }

  _intFromString(String data) {
    return double.parse(data.codeUnits.reversed.join('').substring(0, 5))
        .floor();
  }

  String get publicIdentifier {
    int a = _intFromString(sender);
    int b = responseTo != null && responseTo!.isNotEmpty
        ? _intFromString(responseTo!)
        : _intFromString(id);

    return (a + b).toRadixString(16).substring(0, 4);
  }

  bool get upvote {
    return upvotedBy.contains(userId);
  }

  bool get markedInappropriateBySender {
    if (votedInappropriateBy == null) return false;
    return votedInappropriateBy!.contains(userId);
  }

  bool get own {
    return userId == sender;
  }

  void toggleUpvote() {
    if (!upvote) {
      upvotedBy.add(userId);
      numOfUpvotes++;
    } else {
      upvotedBy.removeWhere((element) => element == userId);
      numOfUpvotes--;
    }
  }

  BoardItem(
      this.created,
      this.id,
      this.body,
      this.category,
      this.responseTo,
      this.sender,
      this.title,
      this.commentsDisabled,
      this.numOfInappropriateFlags,
      this.numOfUpvotes,
      this.public,
      this.readBy,
      this.recipients,
      this.removed,
      this.upvotedBy,
      this.children,
      this.votedInappropriateBy,
      this.senderRole);

  BoardItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        body = json['body'],
        category = json['category'],
        commentsDisabled = json['commentsDisabled'],
        created = DateTime.fromMillisecondsSinceEpoch(json['created'] * 1000),
        numOfInappropriateFlags = json['num_of_inappropriate_flags'] as int,
        numOfUpvotes = json['num_of_upvotes'] as int,
        public = json['public'],
        readBy = json['read_by'],
        recipients = json['recipients'],
        removed = json['removed'],
        responseTo = json['response_to'],
        sender = json['sender'],
        title = json['title'],
        upvotedBy = json['upvoted_by'] as List,
        votedInappropriateBy = json['voted_inappropriate_by'] as List,
        senderRole = json['sender_role'] ?? 'resident';

  BoardItem.createNew(String text, String categoryId, String? selectedItem,
      String uid, String? senderRole)
      : created = DateTime.now(),
        id = 'waiting_response',
        body = text,
        category = categoryId,
        responseTo = selectedItem,
        sender = uid,
        title = '',
        public = false,
        numOfInappropriateFlags = 0,
        numOfUpvotes = 0,
        removed = false,
        commentsDisabled = false,
        readBy = [],
        upvotedBy = [],
        recipients = [],
        children = [],
        votedInappropriateBy = [],
        waitingResponse = true,
        senderRole = senderRole ?? 'resident';
}
