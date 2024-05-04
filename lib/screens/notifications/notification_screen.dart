import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/tools/common.dart';

import '../../config.dart';
import '../../models/notification.dart';
import '../../widgets/common/dwell_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DwellSingleNotificationWidget extends StatelessWidget {
  const DwellSingleNotificationWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DwellNotification data;

  @override
  Widget build(BuildContext context) {
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
      else
        return "Not implemented yet";
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: DwellTitle(title: S.of(context).notification),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: DwellColors.background,
        ),
        padding: EdgeInsets.all(20),
        child: Column(
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    data.body ?? '',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
      ),
    );
  }
}
