import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/directory.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';


class DirectFileMock extends Mock implements DirectFile {}
class DirectoryMock extends Mock implements Directory {}

late DirectFile testFile;
late DirectFile testFileClone;
late DirectFile testInsertFile;

void main() {

  group("Testing File Clone Method", () {
   setUp(() {
    testFile = DirectFile(2);
    testFile.insert(FixedLengthRegister(270));
    testFile.insert(FixedLengthRegister(946));
    testFile.status();
    testFileClone = testFile.clone();
    testFileClone.status();
    } );

    test("Checking that are not the same object", () {
      expect(testFile == testFileClone, false);
    });

    test("Checking that both files have the same content - Checking Hash Table", () {
      expect(listEquals(testFile.getDirectory().hash,testFileClone.getDirectory().hash),true);
      expect(testFile.getDirectory().hash == testFileClone.getDirectory().hash ,false);
    });

    test("Checking that both files have the same content - Checking Freed List", () {
      expect(listEquals(testFile.getFreedList(),testFileClone.getFreedList()),true);
      expect(testFile.getFreedList() == testFileClone.getFreedList() ,false); 
    });

    test("Checking that both files have the same content - Checking Buckets", () {
      var bucketList = testFile.getFileContent();
      var bucketListClone = testFileClone.getFileContent();
     
      expect(bucketList.length,bucketListClone.length);
      if (bucketList.length == bucketListClone.length){
        for (var bucket in bucketList){
          var bucketClone = bucketListClone[bucket.id];
          expect(bucket.size,bucketClone.size);
          expect(bucket.id,bucketClone.id);
          expect(bucket.len,bucketClone.len);
          expect(bucket.status,bucketClone.status);
          expect(bucket.bits,bucketClone.bits);

          for (var record in bucket.getList()){
              int index = bucket.getList().indexOf(record);
              expect(record.value,bucketClone.getRegbyIndex(index)?.value);
            }
          }
      }    
    });

  });
 
}