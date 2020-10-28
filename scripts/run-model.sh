export PATH=/opt/h2oai/dai:/opt/h2oai/dai/python/bin/::$PATH
#
dai-env.sh python /scripts/${1}/${1}-model-1.9.0.${2}.py > /job/run-${1}-model-log 2>&1
