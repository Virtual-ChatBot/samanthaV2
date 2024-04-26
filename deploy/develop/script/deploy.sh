#deploy.sh
HOME=/home/samantha/tomcat_data
WAR_NAME=ROOT.war
WAIT_TIME=10
echo "> build 파일명: $WAR_NAME"

#Jenkins 환경 변수에서 전달한 값
DOCKER_PASSWORD=$1
SERVER_IP=$2
PROD1_PORT=$3
PROD2_PORT=$4
SERVER_LIST=$5

#스크립트 내에서 변수 사용
echo "Docker Password: $DOCKER_PASSWORD"
echo "Server IP: $SERVER_IP"
echo "Prod1 Port: $PROD1_PORT"
echo "Prod2 Port: $PROD2_PORT"
echo "Server Config: $SERVER_LIST"

#===================================생존 서버 확인=====================================
echo "> 서버 체크 시작"
echo "> curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health"

for retry_count in {1..3};
do
  response=$(curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health)
  up_count=$(echo $response | grep 'UP' | wc -l)
  echo "> $retry_count : $response  : $up_count"
  if [ $up_count -ge 1 ]; then
    echo "> 서버 health 체크 성공"
    break
  fi
  if [ $retry_count -eq 3 ]; then
    echo "> 서버 health 체크 실패"
    exit 1
  fi
  echo "> 실패 10초후 재시도"
  sleep $WAIT_TIME
done

#===================================프로세스 종료======================================
loop=1
limitLoop=30
flag='false'

echo "> 구동중인 애플리케이션 확인"
response=$(curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health)
up_count=$(echo $response | grep 'UP' | wc -l)
  if [ $up_count -eq 0 ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 서버 종료하지 않습니다."
    flag='true'
else
  echo "> [$SERVER_LIST] 서버를 재시작합니다."
  echo $DOCKER_PASSWORD | sudo -S docker restart $SERVER_LIST
  sleep $WAIT_TIME
  while [ $loop -le $limitLoop ]
  do
    response=$(curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health)
    up_count=$(echo $response | grep 'UP' | wc -l)
    if [ $up_count -eq 0 ]; then
        echo "> 성공적으로 서버를 재시작하였습니다."
        flag='true'
        break
    else
        echo "> [$loop/$limitLoop] $SERVER_LIST 서버 종료를 기다리는중입니다."
        loop=$(( $loop + 1 ))
        sleep 1
        continue
    fi
  done
fi
if [ $flag == 'false' ]; then
    echo "> 서버 강제종료 시도"
    if [ $loop -gt $limitLoop ]; then
        echo "> 서버 종료를 기다리는 동안 시간이 초과되었습니다. 강제 종료를 시도합니다."
        sleep $WAIT_TIME
        echo $DOCKER_PASSWORD | sudo -S docker restart $SERVER_LIST
    else
        echo "> [$SERVER_LIST] 프로세스 강제 종료합니다."
        sleep $WAIT_TIME
        echo $DOCKER_PASSWORD | sudo -S docker restart $SERVER_LIST
    fi
fi

#=======================================배포===========================================
# Prod1 작업
# (1.1)
#BUILD_PATH_PROD1=$(ls -tr $HOME/$SERVER_LIST/*.war | tail -1)
#WAR_PATH_PROD1=$(basename $BUILD_PATH_PROD1)
#echo "> build file for prod1: $WAR_PATH_PROD1"
#
## (1.2)
#echo "> copy build file for prod1"
#DEPLOY_PATH_PROD1=$HOME/prod1
#if [ ! -d $DEPLOY_PATH_PROD1 ]; then
#  mkdir $DEPLOY_PATH_PROD1
#fi
#cp $BUILD_PATH_PROD1 $DEPLOY_PATH_PROD1

#echo "> 배포"
#echo "> 파일명" $HOME/$WAR_NAME
#echo $DOCKER_PASSWORD | sudo -S docker restart prod1
