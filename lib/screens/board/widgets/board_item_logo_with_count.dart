import '../../../models/board_item.dart';
import '../../../tools/common.dart';
import 'package:flutter/material.dart';

class BoardItemLogoWithCount extends StatelessWidget {
  const BoardItemLogoWithCount({
    Key? key,
    required this.boardItem,
    required this.assetImage,
    required this.selected,
  }) : super(key: key);

  final BoardItem boardItem;
  final String assetImage;
  final BoardItemLogo selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: Text(
              selected == BoardItemLogo.messages
                  ? boardItem.children.length.toString()
                  : boardItem.numOfUpvotes.toString(),
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Sofia Pro',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Image.asset(
              assetImage,
              scale: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
