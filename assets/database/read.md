# Database Preparing for project

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
