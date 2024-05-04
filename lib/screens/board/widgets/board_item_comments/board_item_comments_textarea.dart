import '../../../../config.dart';
import '../../../../models/board_item.dart';
import 'package:flutter/material.dart';

class BoardItemCommentsTextArea extends StatelessWidget {
  const BoardItemCommentsTextArea({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.only(top: 6, right: 6),
      child: Text(
        boardItem.body.trim(),
        style: TextStyle(
            color: boardItem.own ? DwellColors.primaryOrange : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: "Sofia Pro"),
        maxLines: 200,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
