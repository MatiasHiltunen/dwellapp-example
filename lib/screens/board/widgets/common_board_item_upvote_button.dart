import 'package:Kuluma/providers/board_provider.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../models/board_item.dart';
import 'package:flutter/material.dart';

class BoardItemUpvoteButton extends StatefulWidget {
  const BoardItemUpvoteButton(
      {Key? key, required this.boardItem, required this.boardItemType})
      : super(key: key);

  final BoardItem boardItem;
  final BoardItemType boardItemType;

  @override
  _BoardItemUpvoteButtonState createState() => _BoardItemUpvoteButtonState();
}

class _BoardItemUpvoteButtonState extends State<BoardItemUpvoteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: GestureDetector(
        onTap: () => Provider.of<BoardProvider>(context, listen: false)
            .toggleUpvote(widget.boardItem),
        child: Container(
          margin: EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
              color: widget.boardItem.upvote
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              borderRadius: widget.boardItemType == BoardItemType.threads
                  ? BorderRadius.only(topRight: Radius.circular(5))
                  : BorderRadius.all(Radius.circular(5))),
          child: widget.boardItem.waitingResponse
              ? SpinKitRipple(
                  color: Colors.white,
                )
              : widget.boardItem.upvote
                  ? Image.asset(
                      'assets/images/thumbs-up-orange.png',
                      scale: 1.5,
                    )
                  : Image.asset(
                      'assets/images/thumbs-up-white.png',
                      scale: 1.5,
                    ),
        ),
      ),
    );
  }
}
