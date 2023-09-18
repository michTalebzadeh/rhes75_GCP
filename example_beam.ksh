#!/bin/ksh

ENVFILE=/home/hduser/dba/bin/environment.ksh

if [[ -f $ENVFILE ]]
then
        . $ENVFILE
else
        echo "Abort: $0 failed. No environment file ( $ENVFILE ) found"
        exit 1
fi

python3 -m apache_beam.examples.wordcount --input gs://dataflow-samples/shakespeare/kinglear.txt \
                                         --output gs://etcbucket/counts \
                                         --runner DataflowRunner \
                                         --project ${GCPPROJECT} \
                                         --region ${GCPREGION} \
                                         --temp_location gs://tmp_storage_bucket/tmp/

