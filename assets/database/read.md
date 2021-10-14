//Database readme
//from time to time you will need to make these parts into db file.
//The command is here.

cat tipitaka_pali_part.* > tipitaka_pali.db

//To split the files again type this: (period at end is important)
split -b 50000k tipitaka_pali.db tipitaka_pali_part.
