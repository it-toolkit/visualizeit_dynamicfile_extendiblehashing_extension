# Extendible Hashing Extension

This is the Extendible Hashing on Direct Files extension usage doc.

Extension id: `extendible_hashing`

With this extension it is possible to create a file organized with the extensible hashing technique. It is possible to select the size of the buckets that will contain fixed length records. 

In the extensible hashing technique, the hash function will be used to access the table (hash table) of bucket addresses. This extensible version of hashing is also known as postfix bits because it considers the last bits of a record key to determine in the hash table the bucket number that contains the record.
  
## Available commands

### extendiblehashing-create

Creates an empty file with the given maximum bucket capacity. As an optional feature you can pass the initial values of the file. The bucket size must be always greater than zero.

#### Arguments

| Name               | Type     | Position | Required | Default value | Description                   |
|--------------------|----------|----------|----------|---------------|-------------------------------|
| bucketSize         | int      | 0        | true     | -             | Must be in range ( 0 , 1000 ] |
| initialValues      | intArray | 1        | true     | -             | -                             |

### extendiblehashing-insert

Inserts the provided value into the file. This method considers when the bucket suffers an overflow and procedes according to the correspondent algorithm. The hash table will be modified according to the algorithm, updated or duplicated depending on the case.

#### Arguments

| Name  | Type | Position | Required | Default value | Description |
|-------|------|----------|----------|---------------|-------------|
| value | int  | 0        | true     | -             | -           |

### extendiblehashing-remove

Removes the provided value from the file, if it exists. This method considers when the bucket should be released and added to the list of freed buckets or when the bucket should be saved in an empty state. The hash table will be modified according to the algorithm, updated or reduced depending on the case.

#### Arguments

| Name  | Type | Position | Required | Default value | Description |
|-------|------|----------|----------|---------------|-------------|
| value | int  | 0        | true     | -             | -           |

### extendiblehashing-find

Return the true if the value exists in the file. if not return false.

#### Arguments

| Name  | Type | Position | Required | Default value | Description |
|-------|------|----------|----------|---------------|-------------|
| value | int  | 0        | true     | -             | -           |

#### Usage example

```yaml
name: "..."
group: "..."
description: ""
scenes:
  - name: First scene
    extensions: ['extendible_hashing']
    description: Extendible Hashing Sample
    initial-state:
      - extendiblehashing-create: 
          bucketSize: 3, 
          initialValues: [270, 946, 741]
    transitions:
      - extendiblehashing-insert: 446
      - extendiblehashing-insert: 123
      - extendiblehashing-find: 270
      - extendiblehashing-remove: 946
```