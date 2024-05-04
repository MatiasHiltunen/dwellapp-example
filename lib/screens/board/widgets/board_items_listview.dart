import '../../../models/board_item.dart';
import 'package:flutter/material.dart';

import 'board_item/board_item.dart';

class BoardItemsListView extends StatelessWidget {
  final List<BoardItem> boardItems;
  const BoardItemsListView(
    this.boardItems, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return BoardItemWidget(boardItem: boardItems[index]);
      },
      itemCount: boardItems.length,
    );
  }
}
