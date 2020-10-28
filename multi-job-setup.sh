#   multi-job-setup.sh  <beginning container> <ending container> 
#   Example:  multi-job-setup.sh   1 12
#             multi-job-setup.sh   13 32
#   Description: This script creates a working directory for each container and starts all the containers. 
#
export PATH=.:$PATH
[ $# -ne 2 ] && { echo "Usage: multi-job-setup.sh   <beginning container>  <end container> >"; exit 1; }


#   If the H2O docker container image has not been installed(loaded), 
#   Please refer to the the whitepaper for instructions 
#   required to setup the containers and run H2O DriverlessAI`

#   Copy an active H2O license into the directory
#
#  job-template/license
#
#
port1=12345

work=`pwd`


for jobs  in `seq $1 $2 `
do
seq=$(($jobs-1))

cd $work
rm -rf job-$jobs
cp -rf job-template job-$jobs
cd job-$jobs
$work/make.sh $(( $port1+$seq   ))   > job/setup-job-$jobs-log 2>&1
echo $jobs > job/job-index
done

echo "The following dockers are active"

for i in `docker ps -q`
do
echo "Installing prerequisites in docker container"
docker exec -it $i cp /etc/hostname  /job/hostname
#docker exec -it $i cat /job/hostname /job/job-index
docker exec -u 0:0 -it $i yum -y install libtirpc tk
done
