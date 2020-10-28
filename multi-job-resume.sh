#   multi-job-resume.sh  <beginning container> <ending container> 
#   Example:  multi-job-resume.sh   1 12
#             multi-job-resume.sh   13 32
#   Description: This script is used to create containers reusing the existing working directory 
#   job-NN previously created by  multi-job-setup.sh
#   The difference between  multi-job-setup.sh and  multi-job-resume.sh is:
#   multi-job-setup.sh  creates new job-NN working directories 
#   multi-job-resume.sh uses existing job-NN directories
#
[ $# -ne 2 ] && { echo "Usage: multi-job-resume.sh   <beginning container>  <end container> >"; exit 1; }
export PATH=.:$PATH

#
port1=12345
work=`pwd`

for jobs  in `seq $1 $2 `
do
seq=$(($jobs-1))

cd $work
cd job-$jobs
echo $jobs > job/job-index
$work/make.sh $(( $port1+$seq   ))   > job/resume-job-$jobs-log 2>&1
echo $jobs > job/job-index
done

wait

echo "The following dockers are active"

for i in `docker ps -q`
do
echo "Installing prerequisites in docker container  "  $i
docker exec -it $i cp /etc/hostname  /job/hostname
#docker exec -it $i cat /job/hostname /job/job-index
docker exec  -u 0 -it $i yum -y install libtirpc tk
done
