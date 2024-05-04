class Unauthorized implements Exception {
  String cause;
  Unauthorized(this.cause);
}
