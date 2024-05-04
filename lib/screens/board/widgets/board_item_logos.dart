import 'package:Kuluma/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../models/board_item.dart';
import '../../../tools/common.dart';
import 'package:flutter/material.dart';

import 'board_item_logo_with_count.dart';

class BoardItemBottomLogos extends StatelessWidget {
  const BoardItemBottomLogos({
    Key? key,
    required this.boardItem,
  }) : super(key: key);

  final BoardItem boardItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      // color: Colors.blueAccent,
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            /* width: 120, */
            // color: Colors.cyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (boardItem.senderRole == Role.maintainer.asString())
                  Container(
                    width: 50,
                    padding: EdgeInsets.only(top: 2),
                    // color: Colors.cyanAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/das_logo.png',
                          scale: 1.7,
                        ),
                      ],
                    ),
                  ),
                if (boardItem.senderRole == Role.admin.asString())
                  Container(
                    width: 50,
                    padding: EdgeInsets.only(top: 2),
                    // color: Colors.cyanAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "DEV",
                          style: TextStyle(
                              color: DwellColors.primaryBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                if (boardItem.children.length > 0)
                  BoardItemLogoWithCount(
                    boardItem: boardItem,
                    assetImage: 'assets/images/messages.png',
                    selected: BoardItemLogo.messages,
                  ),
                if (boardItem.numOfUpvotes > 0)
                  BoardItemLogoWithCount(
                    boardItem: boardItem,
                    assetImage: 'assets/images/thumbs-up-op.png',
                    selected: BoardItemLogo.upvote,
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: Text(
              DateFormat.yMd().format(boardItem.created.toLocal()) +
                  ', ' +
                  DateFormat.Hm()
                      .format(boardItem.created.toLocal())
                      .replaceAll('.', ':'),
              style: TextStyle(
                  color: DwellColors.backgroundLight, fontFamily: 'Sofia Pro'),
            ),
          ),
        ],
      ),
    );
  }
}
