#deploy_server.sh
HOME=/home/samantha/tomcat_data
WAR_NAME=ROOT.war
WAIT_TIME=10

# Jenkins 환경 변수에서 전달한 값
DOCKER_PASSWORD=$1
SERVER_IP=$2
PROD1_PORT=$3
PROD2_PORT=$4

# 스크립트 내에서 변수 사용
echo "Docker Password: $DOCKER_PASSWORD"
echo "Server IP: $SERVER_IP"
echo "Prod1 Port: $PROD1_PORT"
echo "Prod2 Port: $PROD2_PORT"

# Prod1 작업
# (1.1)
BUILD_PATH_PROD1=$(ls -tr ${HOME}/prod1/*.war | tail -1)
WAR_PATH_PROD1=$(basename $BUILD_PATH_PROD1)
echo "> build file for prod1: $WAR_PATH_PROD1"

# (1.2)
echo "> copy build file for prod1"
DEPLOY_PATH_PROD1=${HOME}/prod1/
if [ ! -d $DEPLOY_PATH_PROD1 ]; then
  mkdir $DEPLOY_PATH_PROD1
fi
cp $BUILD_PATH_PROD1 $DEPLOY_PATH_PROD1
#===================================생존 서버 확인=====================================
#===================================프로세스 종료======================================
echo "> Check application PID for prod1."
CURRENT_PID_PROD1=$(pgrep -f -n $WAR_NAME)
echo "$CURRENT_PID_PROD1"
#=======================================배포===========================================
if [ -z $CURRENT_PID_PROD1 ]; then
    echo "> Restarting Docker container for prod1"
    echo "$DOCKER_PASSWORD" | sudo -S docker restart prod1
    sleep $WAIT_TIME
fi
#===============================현재 서버 Health check=================================

# Prod2 작업
# (2.1)
BUILD_PATH_PROD2=$(ls -tr ${HOME}/prod2/*.war | tail -1)
WAR_PATH_PROD2=$(basename $BUILD_PATH_PROD2)
echo "> build file for prod2: $WAR_PATH_PROD2"

# (2.2)
echo "> copy build file for prod2"
DEPLOY_PATH_PROD2=${HOME}/prod2/
if [ ! -d $DEPLOY_PATH_PROD2 ]; then
  mkdir $DEPLOY_PATH_PROD2
fi
cp $BUILD_PATH_PROD2 $DEPLOY_PATH_PROD2
#===================================생존 서버 확인=====================================
#===================================프로세스 종료======================================
echo "> Check application PID for prod2."
CURRENT_PID_PROD2=$(pgrep -f -n $WAR_NAME)
echo "$CURRENT_PID_PROD2"
#=======================================배포===========================================
if [ -z $CURRENT_PID_PROD2 ]; then
    sleep $WAIT_TIME
    echo "> Restarting Docker container for prod2"
    echo "$DOCKER_PASSWORD" | sudo -S docker restart prod2
fi
#===============================현재 서버 Health check=================================