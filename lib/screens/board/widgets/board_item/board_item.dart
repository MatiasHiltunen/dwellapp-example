import 'package:Kuluma/screens/board/widgets/common_board_item_delete_button.dart';
import 'package:flutter/material.dart';

import '../../../../tools/common.dart';
import '../../../../models/board_item.dart';
import '../../../../screens/board/board_item_view_screen.dart';
import '../../../../config.dart';
import '../board_item_logos.dart';
import '../common_board_item_menu_button.dart';
import '../common_board_item_upvote_button.dart';
import 'board_item_textarea.dart';

class BoardItemWidget extends StatefulWidget {
  const BoardItemWidget({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  _BoardItemWidgetState createState() => _BoardItemWidgetState();
}

class _BoardItemWidgetState extends State<BoardItemWidget> {
  bool _debug = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        if (currentScope.hasPrimaryFocus == currentScope.hasFocus)
          Navigator.pushNamed(context, BoardItemViewScreen.routeName,
              arguments: widget.boardItem);
      },
      child: Container(
        height: _debug ? 270 : 135,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: DwellColors
                .background /* widget.boardItem.own
              ? DwellColors.backgroundDark.withOpacity(0.8)
              : DwellColors.background, */
            ),
        padding: EdgeInsets.fromLTRB(12, 6, 6, 6),
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(top: 6),
                width: width - 74,
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoardItemTextArea(boardItem: widget.boardItem),
                    BoardItemBottomLogos(boardItem: widget.boardItem),
                    /*   if (_debug) ...[
                      Text("id: " + widget.boardItem.id),
                      Text("own: " + widget.boardItem.own.toString()),
                      Text("created: " + widget.boardItem.created.toString()),
                      Text("reported count: " +
                          widget.boardItem.numOfInappropriateFlags.toString()),
                      Text("waiting response: " +
                          widget.boardItem.waitingResponse.toString()),
                      Text("reported by me: " +
                          widget.boardItem.markedInappropriateBySender
                              .toString()),
                      Text("response to: " +
                          widget.boardItem.responseTo.toString()),
                      if (widget.boardItem.recipients != null)
                        Text("recipients: " +
                            widget.boardItem.recipients.toString()),
                      Text("is parent: " + widget.boardItem.parent.toString()),
                      Text("selected item: " +
                          Provider.of<BoardProvider>(context, listen: false)
                              .selectedItem
                              .toString()),
                    ] */
                  ],
                ),
              ),
              Container(
                width: 40,
                child: Column(
                  children: [
                    widget.boardItem.own
                        ? BoardItemDeleteButton(
                            boardItem: widget.boardItem,
                            boardItemType: BoardItemType.threads,
                          )
                        : BoardItemUpvoteButton(
                            boardItem: widget.boardItem,
                            boardItemType: BoardItemType.threads,
                          ),
                    BoardItemMenuButton(
                      boardItem: widget.boardItem,
                      boardItemType: BoardItemType.threads,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
