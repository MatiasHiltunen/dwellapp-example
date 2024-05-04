import 'package:Kuluma/config.dart';

import '../../../../models/board_item.dart';
import 'package:flutter/material.dart';

class BoardItemTextArea extends StatelessWidget {
  const BoardItemTextArea({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, right: 6),
      child: Text(
        boardItem.body,
        style: TextStyle(
            color: boardItem.own ? DwellColors.primaryOrange : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: "Sofia Pro"),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
