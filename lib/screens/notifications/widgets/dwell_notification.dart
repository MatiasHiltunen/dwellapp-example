import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/notification.dart';
import '../../../config.dart';

class DwellNotificationWidget extends StatelessWidget {
  const DwellNotificationWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DwellNotification data;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final S s = S.of(context);

    String _title(NotificationType notificationType, int reactions) {
      if (notificationType == NotificationType.responsesToThreadCount)
        return reactions <= 1
            ? s.notificationsSomeoneCommented
            : '$reactions ' + s.notificationsCommentsCount;
      else if (notificationType == NotificationType.upvotesToMessageCount)
        return reactions <= 1
            ? s.notificationsCommentLiked
            : '$reactions ' + s.notificationsLikedCount;
      else if (notificationType ==
          NotificationType.messageFlaggedAsInappropriateCount)
        return s.notificationsMessageReported;
      else if (notificationType == NotificationType.freezeAccount)
        return s.notificationsAccountFreezed;
      else if (notificationType == NotificationType.adminNotifiedAllFromBoard)
        return 'Ylläpitäjä kirjoitti palstalle';
      else
        return "Not implemented yet";
    }

    return ColorFiltered(
      colorFilter: data.seen
          ? ColorFilter.mode(Colors.black26, BlendMode.darken)
          : ColorFilter.mode(DwellColors.background, BlendMode.lighten),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white54)),
            color: data.seen
                ? DwellColors.backgroundDark
                : DwellColors.background),
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _title(data.notificationType, data.reactions),
                        style: TextStyle(
                          color: Color(0xFF1AA7AC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: w - 50,
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        data.body ?? '',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        DateFormat.yMd('fi')
                            .add_jm()
                            .format(data.created)
                            .toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
