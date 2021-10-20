#!/bin/bash

echo spliting database file per 50MB
split -b 50000k tipitaka_pali.db tipitaka_pali_part.
echo deleting database file
rm tipitaka_pali.db
echo success