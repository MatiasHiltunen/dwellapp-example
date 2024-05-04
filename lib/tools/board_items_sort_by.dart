class SortBy {
  static const created = 'created';
  static const upvotes = 'num_of_upvotes';
  String selected = created;

  void toggle() {
    selected = selected == created ? upvotes : created;
  }
}
