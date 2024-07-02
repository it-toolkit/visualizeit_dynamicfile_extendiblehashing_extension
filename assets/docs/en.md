# Extendible Hashing Extension

This is the Extendible Hashing on Direct Files extension usage doc.

With this extension it is possible to create a file organized with the extensible hashing technique. It is possible to select the size of the buckets that will contain fixed length records. 
In the extensible hashing technique, the hash function will be used to access the table (hash table) of bucket addresses. This extensible version of hashing is also known as postfix bits because it considers the last bits of a record key to determine in the hash table the bucket number that the record contains.
  
## Available commands

### extendiblehashing-create

Creates an empty file with the given maximum bucket capacity. As an optional feature you can pass the initial values of the file. The bucket size must be always greated than zero.

### extendiblehashing-insert

Inserts the provided value into the file. This method considers when the bucket suffers an overflow and procedes according to the correspondent algorithm. The hash table will be modified according to the algorithm, updated or duplicated depending on the case.

### extendiblehashing-remove

Removes the provided value from the file, if it exists. This method considers when the bucket should be released and added to the list of freed buckets or when the bucket should be saved in an empty state. The hash table will be modified according to the algorithm, updated or reduced depending on the case.

### extendiblehashing-find

Return the true if the value exists in the file. if not return false.

#### Usage example

```
name: "..."
group: "..."
description: ""
scenes:
  - name: First scene
    extensions: ['extendible-hashing-extension']
    description: Extendible Hashing Sample
    initial-state:
      - extendiblehashing-create: [3, ["270","946","741"]]
    transitions:
      - extendiblehashing-insert: [446]
      - extendiblehashing-insert: [123]
      - extendiblehashing-find: [270]
      - extendiblehashing-remove: [946]
```