import 'package:Kuluma/tools/common.dart';
import 'package:flutter/material.dart';
import '../../../../models/board_item.dart';
import '../../../../config.dart';
import '../board_item_logos.dart';
import '../board_item_comments/board_item_comments_textarea.dart';

import '../common_board_item_delete_button.dart';
import '../common_board_item_menu_button.dart';
import '../common_board_item_upvote_button.dart';

class BoardItemInCommentsWidget extends StatelessWidget {
  const BoardItemInCommentsWidget({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return boardItem.parent
        ? BoardItemCommentsParent(boardItem: boardItem, width: width)
        : BoardItemComments(boardItem: boardItem, width: width);
  }
}

class BoardItemComments extends StatefulWidget {
  const BoardItemComments({
    Key? key,
    required this.boardItem,
    required this.width,
  }) : super(key: key);

  final BoardItem boardItem;
  final double width;

  @override
  _BoardItemCommentsState createState() => _BoardItemCommentsState();
}

class _BoardItemCommentsState extends State<BoardItemComments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      /*  constraints: BoxConstraints(maxHeight: 220, minHeight: 100), */
      decoration: BoxDecoration(
        color: DwellColors.background,
      ),
      padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
      margin: EdgeInsets.all(0.0),
      child: Container(
        child: Stack(
          children: [
            ColoredDot(boardItem: widget.boardItem),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 6),
                    width: widget.width - 74,
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoardItemCommentsTextArea(boardItem: widget.boardItem),
                        BoardItemBottomLogos(boardItem: widget.boardItem),
                      ],
                    ),
                  ),
                  BoardItemCommentsButtons(
                    boardItem: widget.boardItem,
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -25),
              child: Divider(
                color: Theme.of(context).primaryColor,
                indent: 60,
                endIndent: 60,
                thickness: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BoardItemCommentsParent extends StatefulWidget {
  const BoardItemCommentsParent({
    Key? key,
    required this.boardItem,
    required this.width,
  }) : super(key: key);

  final BoardItem boardItem;
  final double width;

  @override
  _BoardItemCommentsParentState createState() =>
      _BoardItemCommentsParentState();
}

class _BoardItemCommentsParentState extends State<BoardItemCommentsParent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DwellColors.background,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
      margin: EdgeInsets.all(0.0),
      child: Stack(
        children: [
          ColoredDot(boardItem: widget.boardItem),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 6),
                  width: widget.width - 74,
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoardItemCommentsTextArea(boardItem: widget.boardItem),
                      BoardItemBottomLogos(boardItem: widget.boardItem),
                    ],
                  ),
                ),
                BoardItemCommentsButtons(
                  boardItem: widget.boardItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoardItemCommentsButtons extends StatefulWidget {
  const BoardItemCommentsButtons({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  _BoardItemCommentsButtonsState createState() =>
      _BoardItemCommentsButtonsState();
}

class _BoardItemCommentsButtonsState extends State<BoardItemCommentsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.boardItem.own
              ? BoardItemDeleteButton(
                  boardItem: widget.boardItem,
                  boardItemType: BoardItemType.comments)
              : BoardItemUpvoteButton(
                  boardItem: widget.boardItem,
                  boardItemType: BoardItemType.comments,
                ),
          BoardItemMenuButton(
            boardItem: widget.boardItem,
            boardItemType: BoardItemType.comments,
          ),
        ],
      ),
    );
  }
}

class ColoredDot extends StatelessWidget {
  const ColoredDot({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-5, -10),
      child: Text(
        boardItem.publicIdentifier,
        style: TextStyle(
          color: DwellColors.backgroundLight,
          fontSize: 8,
        ),
      ),
    );
  }
}
