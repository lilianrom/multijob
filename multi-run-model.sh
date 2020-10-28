#
#   Usage: multi-run-model.sh  <beginning container> <end container>  <cpu|gpu>
#   Description:  This script starts the training of a model in each of the containers
#
[ $# -ne 3 ] && { echo "Usage: multi-run-model.sh  <beginning container> <end container>  <cpu|gpu>"; exit 1; }
work=`pwd`
job=0
for jobs  in `seq $1 $2   `
do
export job=$(($job+1))
cd $work/job-$jobs/job
echo "Running model in container ", `cat job-index` `cat hostname` `sed -n ${jobs}p < workloads.txt`
docker exec -d  `cat hostname`  /bin/bash /scripts/run-model.sh `sed -n ${jobs}p < workloads.txt` $3 > logx-$job
done
