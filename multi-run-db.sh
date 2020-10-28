#
#   Usage:   multi-run-db.sh   <beginning container>  <end container> >
#   Descriptipn: This script loads 'allyears' data into each of the containers.
#
[ $# -ne 2 ] && { echo "Usage: multi-run-db.sh   <beginning container>  <end container> >"; exit 1; }
work=`pwd`
job=0
for jobs  in `seq $1 $2 `
do
export job=$(($job+1))
cd $work/job-$jobs/job
echo "Loading database into: container ", `cat job-index` `cat hostname` `sed -n ${jobs}p < workloads.txt`
docker exec -i `cat hostname`   /bin/bash /scripts/run-db.sh    `sed -n ${jobs}p < workloads.txt` 
done
