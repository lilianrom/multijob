#
#  This script is used to create a docker container running h2o DriverlessAI
#           multi-job-setup.sh calls this script.
#           Please do not use make.sh directly; simply replace  REPOSITORY:TAG as described below

#The following directories which are created on the host for each container are mapped as volumes inside
#the container
#data  job  license  log  scripts tmp
#Starting a docker container requires a docker image. This is the image that is downloaded from h2o.ai. 
#The instructions are provided in the whitepaper
#

docker run \
--pid=host \
-e NVIDIA_VISIBLE_DEVICES="0,1,2,3" \
--init \
--rm \
-d \
--shm-size=4G \
-u `id -u`:`id -g` \
-p $1:12345 \
-v `pwd`/scripts:/scripts \
-v `pwd`/tmp:/tmp \
-v `pwd`/data:/data \
-v `pwd`/log:/log \
-v `pwd`/job:/job \
-v `pwd`/license:/license \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro \
h2oai/dai-centos7-ppc64le:1.9.0.3-cuda10.0.16
#REPOSITORY:TAG
# Replace REPOSITORY:TAG with  REPOSITORY, TAG information. run "docker image ls"
# Example: h2oai/dai-centos7-ppc64le:1.9.0.1-cuda10.0.8
