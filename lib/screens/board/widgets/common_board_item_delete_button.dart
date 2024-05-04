import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/providers/board_provider.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../models/board_item.dart';
import 'package:flutter/material.dart';

import '../board_item_view_screen.dart';

class BoardItemDeleteButton extends StatefulWidget {
  const BoardItemDeleteButton(
      {Key? key, required this.boardItem, required this.boardItemType})
      : super(key: key);

  final BoardItem boardItem;
  final BoardItemType boardItemType;

  @override
  _BoardItemDeleteButtonState createState() => _BoardItemDeleteButtonState();
}

class _BoardItemDeleteButtonState extends State<BoardItemDeleteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: GestureDetector(
        onTap: () {
          DwellDialog(
            title: S.of(context).boardConfirmDeleteMessageTitle,
            content: S.of(context).boardConfirmDeleteMessageContent,
            acceptText: S.of(context).boardConfirmDeleteMessageAccept,
            cancelText: S.of(context).boardConfirmDeleteMessageCancel,
            onAccept: () {
              Provider.of<BoardProvider>(context, listen: false)
                  .removeBoardItem(widget.boardItem);
              if (widget.boardItem.responseTo == null &&
                  ModalRoute.of(context)?.settings.name ==
                      BoardItemViewScreen.routeName) {
                Navigator.of(context).pop();
              }
            },
          ).show(context: context);
        },
        child: Container(
            margin: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: widget.boardItemType == BoardItemType.threads
                    ? BorderRadius.only(topRight: Radius.circular(5))
                    : BorderRadius.all(Radius.circular(5))),
            child: widget.boardItem.waitingResponse
                ? SpinKitRipple(
                    color: Colors.white,
                  )
                : Image.asset(
                    'assets/images/delete_custom.png',
                    scale: 1.5,
                  )),
      ),
    );
  }
}
