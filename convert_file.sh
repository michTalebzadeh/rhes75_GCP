#!/bin/bash
GZFILE="csvfile.gz"
FILE_NAME=`basename $GZFILE .gz`
BZFILE="$FILE_NAME.bz2"
echo `date` " ""=======  Started compressing file $GZFILE  ======"
gunzip --to-stdout $GZFILE | bzip2 > $BZFILE
if [ $? != 0 ]
then
  echo `date` " ""======= Could not process GZFILE, aborting ======"
  exit 1
else
  echo `date` " ""======= bz2 file $BZFILE created OK ======"
  ls -ltr $BZFILE
  exit 0
fi


