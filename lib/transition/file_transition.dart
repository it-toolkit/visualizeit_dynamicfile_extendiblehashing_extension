abstract class Transition{
  final TransitionType _type;

  Transition(this._type);

  TransitionType get type => _type;

  @override
  String toString() {
    return type.toString();
  }
}

enum TransitionType {
  bucketFound,
  bucketOverflowed,
  bucketCreated,
  bucketFreed,
  bucketEmpty,
  bucketReorganized,
  bucketUpdateHashingBits,
  usingBucketFreed,
  replacemmentBucketFound,
  recordSaved,
  recordDeleted,
  recordFound,
  recordNotFound,
  hashTableDuplicateSize,
  hashTableReduceSize,
  hashTableUpdated,
  hashTableOperation,
  hashTablePointedBucket,
  hashTableReviewed,
  hashTableReviewedSameBucket,
  hashTableReviewedNotSameBucket,
  fileIsEmpty,
  findingBucket,
  freedListOperation;

  @override
  String toString() => name;
}