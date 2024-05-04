import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../tools/logging.dart';
import '../../models/board_item.dart';
import '../../models/dwell_menu_item.dart';
import '../../models/notification.dart';
import '../../providers/board_provider.dart';
import '../../widgets/common/dwell_app_bar.dart';
import '../../widgets/common/dwell_dropdown_menu.dart';
import '../screen_root.dart';
import 'widgets/board_items_listview.dart';
import 'widgets/board_textfield.dart';
import 'board_item_view_screen.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board_screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  DwellNotification? args;
  bool _goingToComments = false;
  TextEditingController textController = TextEditingController();

  Future _fetchBoardItems(
      BoardProvider boardProvider, BuildContext context) async {
    try {
      List<BoardItem> boardItems = await boardProvider.fetchBoardItems();
      _navigateToItem(boardProvider, context, boardItems);
      return boardItems;
    } catch (e) {
      Log.error("Error in board_screen fetch", e);
      if (boardProvider.boardItems != null) return boardProvider.boardItems;
      rethrow;
    }
  }

  void _navigateToItem(
    BoardProvider boardProvider,
    BuildContext context,
    List<BoardItem?>? boardItems,
  ) {
    if (args != null && boardItems != null) {
      BoardItem? boardItem = boardItems.firstWhere(
        (BoardItem? element) {
          return element?.id == args!.immediateParent ||
              element?.id == args!.ref;
        },
      );

      if (boardItem != null) {
        args = null;
        WidgetsBinding.instance?.addPostFrameCallback(
          (timeStamp) {
            boardProvider.selectedItem = null;
            Navigator.pushReplacementNamed(
              context,
              BoardItemViewScreen.routeName,
              arguments: boardItem,
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      args = ModalRoute.of(context)?.settings.arguments as DwellNotification;
    }
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    if (args != null) _goingToComments = true;

    boardProvider.selectedItem = null;
    return ScreenRoot(
      disableSnackbarLauncher: true,
      additionalOnWillPopFunction: () {
        boardProvider.selectedItem = null;
      },
      allowBackbuttonScreenChange: true,
      appBar: DwellAppBar(
        title: DwellDropDownMenu(
          dropdownItems: boardProvider.options,
          titleColor: Colors.white,
          titleText: "Palsta",
          onChanged: (DwellMenuItem item) {
            boardProvider.by = item;
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await boardProvider.fetchBoardItems(true),
        child: Stack(
          children: [
            Container(
              color: Color(0xFFE2E2E2),
              padding: EdgeInsets.only(bottom: 80),
              child: FutureBuilder(
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done &&
                          snap.hasData ||
                      boardProvider.boardItems != null && !snap.hasError) {
                    return _goingToComments
                        ? SpinKitWanderingCubes(
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : BoardItemsListView(
                            Provider.of<BoardProvider>(context).boardItems!);
                  }
                  return SpinKitWanderingCubes(
                    color: Theme.of(context).primaryColor,
                  );
                },
                future: _fetchBoardItems(boardProvider, context),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BoardTextField(textController),
              ),
            )
          ],
        ),
      ),
    );
  }
}
