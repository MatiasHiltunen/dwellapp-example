import '../../../models/board_item.dart';
import 'package:flutter/material.dart';

import 'board_item_comments/board_item_comments.dart';

class BoardItemsListViewInComments extends StatelessWidget {
  final List<BoardItem> boardItems;
  const BoardItemsListViewInComments(
    this.boardItems, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return BoardItemInCommentsWidget(boardItem: boardItems[index]);
      },
      itemCount: boardItems.length,
    );
  }
}
