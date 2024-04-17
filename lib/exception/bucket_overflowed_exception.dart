class BucketOverflowedException implements Exception{
  String cause;
  BucketOverflowedException(this.cause);
}