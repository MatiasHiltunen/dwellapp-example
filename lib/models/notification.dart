import 'package:Kuluma/tools/common.dart';

class DwellNotification {
  final String id;
  final String? body;
  final NotificationType notificationType;
  final String? ref;
  final String? immediateParent;
  final DateTime created;
  String? uid;

  List read;
  int reactions;

  DwellNotification({
    required this.id,
    required this.body,
    required this.created,
    required this.reactions,
    required this.read,
    required this.ref,
    required this.notificationType,
    required this.immediateParent,
  });

  DwellNotification.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        body = json['body'] as String,
        notificationType =
            GetNotificationType.type(json['notification_type'] as String),
        read = json['read'] as List,
        reactions = json['reactions'] as int,
        ref = json['ref'] as String,
        immediateParent = json['immediate_parent'],
        created = DateTime.fromMillisecondsSinceEpoch(
            (json['created'] as int) * 1000);

  bool get isMessage {
    return notificationType == NotificationType.responsesToThreadCount ||
        notificationType == NotificationType.upvotesToMessageCount ||
        notificationType == NotificationType.adminNotifiedAllFromBoard;
  }

  get seen {
    return read.contains(uid);
  }
}

abstract class GetNotificationType {
  static NotificationType type(String typeName) {
    switch (typeName) {
      case 'responses_to_thread_count':
        return NotificationType.responsesToThreadCount;
      case 'upvotes_to_message_count':
        return NotificationType.upvotesToMessageCount;
      case 'message_flagged_as_inappropriate_count':
        return NotificationType.messageFlaggedAsInappropriateCount;
      case 'freeze_account':
        return NotificationType.freezeAccount;
      case 'message_sent_notify_admins':
        return NotificationType.notifyAdmin;
      case 'admin_sent_general_notification':
        return NotificationType.adminGeneralNotification;
      case 'admin_notified_all_from_board':
        return NotificationType.adminNotifiedAllFromBoard;
      default:
        return NotificationType.unknown;
    }
  }
}
