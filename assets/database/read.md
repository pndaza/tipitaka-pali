# Database Preparing for project
Because of Copyright.. the Database has been removed from the GIT
You may find it here: https://drive.google.com/drive/folders/1UI5kI4RdDnGNouPEwEVqu-xOPkrmFuRh?usp=sharing

The File may be mixed copyright and will have a "license" table describing the tables for the different data copyrights which are mostly creative commons nc or the pali data from vri which they claimed as copyright material even though it is public domain from the 6th Buddhist Council.
Some tables may be mixed and copyrighted by field codes (which describe the book name in the dictionary, etc)
Other dictionaries may also be copyrighted and are used with permission or permission is beign sought during the development stages.
Never the less, all are distributed as free and not commerical material and technicalities might need to be worked out.



## Problem with large assets file copy
rootBundle.load method loads all content of

[flutter issues](https://github.com/flutter/flutter/issues/26465)
## To megre part files to db file

```
cat tipitaka_pali_part.* > tipitaka_pali.db
```

## delete all part files

```
rm tipitaka_pali_part.*
```

## To split the files again type this:
(period at end is important)

```
split -b 50000k tipitaka_pali.db tipitaka_pali_part.
```
