import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/directory.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';

class DirectFileMock extends Mock implements DirectFile {}
class DirectoryMock extends Mock implements Directory {}

late DirectFile testFile;
late DirectFile testInsertFile;
void main() {

  var mockFile = DirectFileMock();
  var mockDir = DirectoryMock();

  group("Testing final state of the file after severals inserts and deletions", () {
   setUp(() {
    testFile = DirectFile(3);
    testFile.insert(FixedLengthRegister(270));
    testFile.insert(FixedLengthRegister(946));
    testFile.insert(FixedLengthRegister(741));
    testFile.insert(FixedLengthRegister(446));
    testFile.insert(FixedLengthRegister(123));
    testFile.insert(FixedLengthRegister(376));
    testFile.insert(FixedLengthRegister(458));
    testFile.insert(FixedLengthRegister(954));
    testFile.insert(FixedLengthRegister(973));
    testFile.insert(FixedLengthRegister(426));
    testFile.insert(FixedLengthRegister(410));
    testFile.insert(FixedLengthRegister(789));
    testFile.insert(FixedLengthRegister(484));
    testFile.insert(FixedLengthRegister(305));
    testFile.insert(FixedLengthRegister(462));
    testFile.insert(FixedLengthRegister(809));
    testFile.insert(FixedLengthRegister(459));
  
    testFile.delete(FixedLengthRegister(305));
    testFile.delete(FixedLengthRegister(809));
    testFile.delete(FixedLengthRegister(946));
    testFile.delete(FixedLengthRegister(410));
    testFile.delete(FixedLengthRegister(954));
    testFile.status();
    } );

    test("Checking final state of the file - Checking Hash Table", () {
      when(() => mockDir.hash).thenReturn([2, 6, 4, 0, 2, 6, 1, 0, 2, 6, 5, 0, 2, 6, 1, 0]);
      when(() => mockFile.getDirectory()).thenReturn(mockDir);
      expect(listEquals(testFile.getDirectory().hash,mockFile.getDirectory().hash),true);
    });

    test("Checking final state of the file - Checking Freed List", () {
      when(() => mockFile.getFreedList()).thenReturn([7,3]);
      expect(listEquals(mockFile.getFreedList(),testFile.getFreedList()),true); 
    });

    test("Checking final state of the file - Checking Buckets", () {
      var bucketList = testFile.getFileContent();
      
      expect(bucketList[0].status,BucketStatus.active);
      expect(bucketList[0].bits,2);
      expect(bucketList[0].getRegbyIndex(0)?.value,123);
      expect(bucketList[0].getRegbyIndex(1)?.value,459);

      expect(bucketList[1].status,BucketStatus.full);
      expect(bucketList[1].bits,3);
      expect(bucketList[1].getRegbyIndex(0)?.value,270);
      expect(bucketList[1].getRegbyIndex(1)?.value,446);
      expect(bucketList[1].getRegbyIndex(2)?.value,462);

      expect(bucketList[2].status,BucketStatus.active);
      expect(bucketList[2].bits,2);
      expect(bucketList[2].getRegbyIndex(0)?.value,376);
      expect(bucketList[2].getRegbyIndex(1)?.value,484);

      expect(bucketList[3].status,BucketStatus.freed);
      expect(bucketList[3].bits,5);
      expect(bucketList[3].getRegbyIndex(0)?.value,954);

      expect(bucketList[4].status,BucketStatus.empty);
      expect(bucketList[4].bits,4);
      expect(bucketList[4].len,0);

      expect(bucketList[5].status,BucketStatus.active);
      expect(bucketList[5].bits,4);
      expect(bucketList[5].getRegbyIndex(0)?.value,458);
      expect(bucketList[5].getRegbyIndex(1)?.value,426);

      expect(bucketList[6].status,BucketStatus.full);
      expect(bucketList[6].bits,2);
      expect(bucketList[6].getRegbyIndex(0)?.value,741);
      expect(bucketList[6].getRegbyIndex(1)?.value,973);
      expect(bucketList[6].getRegbyIndex(2)?.value,789);

      expect(bucketList[7].status,BucketStatus.freed);
      expect(bucketList[7].bits,3);
      expect(bucketList[7].getRegbyIndex(0)?.value,809);

    });

  });
 
 group("Testing insertions", () {
    
    setUp((){
      testInsertFile = DirectFile(3);
    });

    test("Checking if the value exists in the file", () {
      testInsertFile.insert(FixedLengthRegister(270));
      expect(testInsertFile.exist(FixedLengthRegister(270)),true); 
    });

    test("Checking if the value already exists in the file", () {
      testInsertFile.insert(FixedLengthRegister(480));
      expect(testInsertFile.insert(FixedLengthRegister(480)),false); 
    });
  
  });

  group("Testing deletion", () {
    test("Checking if the value is no longer in the file after a deletion", () {
      DirectFile file = DirectFile(3);
      file.insert(FixedLengthRegister(270));
      file.insert(FixedLengthRegister(480));
      file.delete(FixedLengthRegister(270));
      expect(file.exist(FixedLengthRegister(270)),false); 
    });

  });

}