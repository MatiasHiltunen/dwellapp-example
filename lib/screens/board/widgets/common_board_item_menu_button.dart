import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/models/board_item.dart';
import 'package:Kuluma/models/dwell_menu_item.dart';
import 'package:Kuluma/providers/board_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/board/board_item_view_screen.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardItemMenuButton extends StatelessWidget {
  const BoardItemMenuButton(
      {Key? key, required this.boardItem, required this.boardItemType})
      : super(key: key);

  final BoardItem boardItem;
  final BoardItemType boardItemType;

  List<DwellMenuItem> boardItemMenu({
    required bool own,
    required bool reported,
    required BuildContext context,
    required String senderRole,
  }) {
    return [
      /* DwellMenuItem(
          name: "Kommentoi", action: DwellMenuAction.comment, sortBy: ''), */
      if (own ||
          context.read<User>().role == Role.admin.asString() ||
          context.read<User>().role == Role.maintainer.asString())
        DwellMenuItem(
            name: "Poista", action: DwellMenuAction.delete, sortBy: ''),
      if (!own &&
          senderRole != Role.admin.asString() &&
          senderRole != Role.maintainer.asString())
        DwellMenuItem(
          name: reported ? 'Peruuta ilmianto' : "Ilmianna",
          action: DwellMenuAction.report,
          sortBy: '',
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DwellMenuAction>(
      child: Container(
        height: 60,
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: boardItemType == BoardItemType.threads
                ? BorderRadius.only(bottomRight: Radius.circular(5))
                : BorderRadius.all(Radius.circular(5))),
        child: boardItem.waitingResponse
            ? SpinKitRipple(
                color: Colors.white,
              )
            : Image.asset(
                'assets/images/dots.png',
                scale: 1.5,
              ),
      ),
      onSelected: (val) {
        val.action(Provider.of<BoardProvider>(context, listen: false),
            boardItem, context);
      },
      itemBuilder: (BuildContext context) {
        return boardItemMenu(
                own: boardItem.own,
                reported: boardItem.markedInappropriateBySender,
                context: context,
                senderRole: boardItem.senderRole!)
            .map((DwellMenuItem item) {
          return PopupMenuItem<DwellMenuAction>(
            value: item.action,
            child: Text(item.name),
          );
        }).toList();
      },
    );
  }
}

extension on DwellMenuAction {
  action(BoardProvider provider, BoardItem item, BuildContext context) {
    switch (this) {
      case DwellMenuAction.comment:
        {
          Log.info("comment");
        }
        break;
      case DwellMenuAction.delete:
        {
          DwellDialog(
            title: S.of(context).boardConfirmDeleteMessageTitle,
            content: S.of(context).boardConfirmDeleteMessageContent,
            acceptText: S.of(context).boardConfirmDeleteMessageAccept,
            cancelText: S.of(context).boardConfirmDeleteMessageCancel,
            onAccept: () {
              provider.removeBoardItem(item);
              if (item.responseTo == null &&
                  ModalRoute.of(context)?.settings.name ==
                      BoardItemViewScreen.routeName) {
                Navigator.of(context).pop();
              }
            },
          ).show(context: context);
        }
        break;
      case DwellMenuAction.hide:
        {
          Log.info("hide");
        }
        break;
      case DwellMenuAction.report:
        {
          Log.info("report");
          provider.toggleInappropriate(item);
        }
        break;
      default:
        {
          Log.info("null");
        }
    }
  }
}
