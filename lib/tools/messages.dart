enum MessageSortBy { newest, mostUpvoted }
enum MessageItemType { thread, response }
enum MessageLandscapeMode { lockToPortrait, fab }

class AddMessageArgumentType {
  MessageItemType type;
  AddMessageArgumentType({this.type = MessageItemType.thread});
}
