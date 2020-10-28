export PATH=/opt/h2oai/dai:/opt/h2oai/dai/python/bin/::$PATH
#
dai-env.sh python /scripts/${1}/${1}-database.py  > /job/run-db-upload-log 2>&1
