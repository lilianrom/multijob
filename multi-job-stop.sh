#
#   Usage: multi-job-stop.sh  <Beginning Container>  < End container > 
#   Descriptipn: This script stops and removes all the containers.
#   The directory structure and the h2o DAI specific data residing in each of the containers
#   is preserved, these directories can be reused to start new containers.
#   Once the directory structure for each job (e.g., job-1, job-2, ..) is created by 
#   multi-job-setup.sh, you can start stop/remove the container and reuse the directory  
#   to restart the container. If you want to reuse the directories, please use
#   multi-job-resume.sh <beginning container> <end container>
#   use multi-job-setup.sh to create new job-NN directories and start new containers
#
[ $# -ne 2 ] && { echo "Usage: multi-job-stop.sh   <beginning container>  <end container> >"; exit 1; }
work=`pwd`
job=0
for jobs  in `seq $1  $2 `
do
export job=$(($job+1))
cd $work/job-$jobs/job
docker stop   `cat hostname`   
rm -f hostname
done
