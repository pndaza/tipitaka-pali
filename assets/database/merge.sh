#!/bin/bash

echo  merging part files to db file
cat tipitaka_pali_part.* > tipitaka_pali.db

echo deleting all part files
rm tipitaka_pali_part.*

echo success