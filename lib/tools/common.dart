enum SortDir { asc, desc }
enum DwellMenuAction { delete, comment, hide, report }
enum BoardItemLogo { upvote, messages }
enum BoardItemAction { upvote, delete, report, hide }
enum BoardItemType { threads, comments }
enum TimeFrame { hourly, weekly, monthly, yearly }
enum BoardingItems { welcome, consumption, board, introduction }
enum NotificationType {
  responsesToThreadCount,
  upvotesToMessageCount,
  messageFlaggedAsInappropriateCount,
  freezeAccount,
  notifyAdmin,
  adminGeneralNotification,
  adminNotifiedAllFromBoard,
  unknown,
}
enum Role { maintainer, admin, resident }

extension CreateRole on Role {
  String asString() {
    if (this == Role.maintainer) return 'maintainer';
    if (this == Role.admin) return 'admin';
    if (this == Role.resident) return 'resident';

    throw Exception(
        "User role is not defined or correct, can't initialize role for the user");
  }
}
