#deploy.sh
HOME=/home/samantha/tomcat_data
WAR_NAME=ROOT.war
WAIT_TIME=5
echo "> build 파일명: $WAR_NAME"

#Jenkins 환경 변수에서 전달한 값
DOCKER_PASSWORD=$1
SERVER_IP=$2
PROD1_PORT=$3
PROD2_PORT=$4

#스크립트 내에서 변수 사용
echo "Docker Password: $DOCKER_PASSWORD"
echo "Server IP: $SERVER_IP"
echo "Prod1 Port: $PROD1_PORT"
echo "Prod2 Port: $PROD2_PORT"

#=======================================배포1===========================================
# Prod1 작업
# (1.1)
BUILD_PATH_PROD1=$(ls -tr $HOME/prod1/*.war | tail -1)
WAR_PATH_PROD1=$(basename $BUILD_PATH_PROD1)
echo "> build file for prod1: $WAR_PATH_PROD1"

# (1.2)
echo "> copy build file for prod1"
DEPLOY_PATH_PROD1=$HOME/prod1
if [ ! -d $DEPLOY_PATH_PROD1 ]; then
  mkdir $DEPLOY_PATH_PROD1
fi
cp $BUILD_PATH_PROD1 $DEPLOY_PATH_PROD1
#===================================생존 서버 확인=====================================
echo "> 5초 후 Health check 시작"
echo "> curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health"

for retry_count in {1..5};
do
  response=$(curl -s http://$SERVER_IP:$PROD1_PORT/actuator/health)
  up_count=$(echo $response | grep 'UP' | wc -l)
  echo "> $retry_count : $response  : $up_count"
  if [ $up_count -ge 1 ]; then
    echo "> 서버 health 체크 성공"
    break
  fi
  if [ $retry_count -eq 5 ]; then
    echo "> 서버 health 체크 실패"
    exit 1
  fi
  echo "> 실패 5초후 재시도"
  sleep $WAIT_TIME
done

#===================================프로세스 종료======================================
loop=1
limitLoop=30
flag='false'

echo "> 구동중인 애플리케이션 pid 확인"
IDLE_PID=(`ps -ef | grep  $WAR_NAME | grep -v 'grep' | awk '{ print $2 }'`)
 if [ ${#IDLE_PID[@]} = 0 ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
  flag='true'
else
  for pid in "${IDLE_PID[@]}"
  do
      echo "> [$pid] gracefully shutdown"
      echo $DOCKER_PASSWORD | sudo -S docker restart prod1
  done
  while [ $loop -le $limitLoop ]
  do
      PID_LIST=(`ps -ef | grep  $WAR_NAME | grep -v 'grep' | awk '{ print $2 }'`)
      if [ ${#PID_LIST[@]} = 0 ]
      then
          echo "> gracefully shutdown success "
          flag='true'
          break
      else
          for pid in "${PID_LIST[@]}"
          do
              echo "> [$loop/$limitLoop] $pid 프로세스 종료를 기다리는중입니다."
          done
          loop=$(( $loop + 1 ))
          sleep 1
          continue
      fi
  done
fi
if [ $flag == 'false' ];
then
    echo "> 프로세스 강제종료 시도"
    sudo ps -ef | grep $WAR_NAME | grep -v 'grep' |  awk '{ print $2 }' | \
    while read PID
    do
        echo "> [$PID] forced shutdown"
        kill -9 $PID
    done
fi
#=======================================배포2===========================================
#echo "> 배포"
#echo "> 파일명" $HOME/$WAR_NAME
#echo $DOCKER_PASSWORD | sudo -S docker restart prod1
sleep $WAIT_TIME

#==================================현재 서버 확인======================================
echo "> 5초 후 Health check 시작"
echo "> curl -s http://$SERVER_IP:$PROD2_PORT/actuator/health"

for retry_count in {1..5}; do
  response=$(sudo curl -s http://$SERVER_IP:$PROD2_PORT/actuator/health)
  up_count=$(echo $response | grep 'UP' | wc -l)
  if [ $up_count -ge 1 ]; then
    echo "> Health check 성공"
    break
  else
    echo "> Health check의 응답을 알 수 없거나 혹은 status가 UP이 아닙니다."
    echo "> Health check: ${response}"
  fi

  if [ $retry_count -eq 5 ]; then
    echo "> Health check 실패. "
    echo "> Nginx에 연결하지 않고 배포를 종료합니다."
    exit 1
  fi

  echo "> Health check 연결 실패. 재시도..."
  sleep $WAIT_TIME
done

#===================================프로세스 종료======================================
loop=1
limitLoop=30
flag='false'

echo "> 구동중인 애플리케이션 pid 확인"
IDLE_PID=(`ps -ef | grep  $WAR_NAME | grep -v 'grep' | awk '{ print $2 }'`)
 if [ ${#IDLE_PID[@]} = 0 ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
  flag='true'
else
  for pid in "${IDLE_PID[@]}"
  do
      echo "> [$pid] gracefully shutdown"
      echo $DOCKER_PASSWORD | sudo -S docker restart prod1
  done
  while [ $loop -le $limitLoop ]
  do
      PID_LIST=(`ps -ef | grep  $WAR_NAME | grep -v 'grep' | awk '{ print $2 }'`)
      if [ ${#PID_LIST[@]} = 0 ]
      then
          echo "> gracefully shutdown success "
          flag='true'
          break
      else
          for pid in "${PID_LIST[@]}"
          do
              echo "> [$loop/$limitLoop] $pid 프로세스 종료를 기다리는중입니다."
          done
          loop=$(( $loop + 1 ))
          sleep 1
          continue
      fi
  done
fi
if [ $flag == 'false' ];
then
    echo "> 프로세스 강제종료 시도"
    sudo ps -ef | grep $WAR_NAME | grep -v 'grep' |  awk '{ print $2 }' | \
    while read PID
    do
        echo "> [$PID] forced shutdown"
        kill -9 $PID
    done
fi
#=======================================배포===========================================
sleep $WAIT_TIME

# Prod2 작업
# (2.1)
BUILD_PATH_PROD2=$(ls -tr $HOME/prod2/*.war | tail -1)
WAR_PATH_PROD2=$(basename $BUILD_PATH_PROD2)
echo "> build file for prod2: $WAR_PATH_PROD2"

# (2.2)
echo "> copy build file for prod2"
DEPLOY_PATH_PROD2=$HOME/prod2
if [ ! -d $DEPLOY_PATH_PROD2 ]; then
  mkdir $DEPLOY_PATH_PROD2
fi
cp $BUILD_PATH_PROD2 $DEPLOY_PATH_PROD2

#echo "> 배포"
#echo "> 파일명" $HOME/$WAR_NAME
#echo $DOCKER_PASSWORD | sudo -S docker restart prod2
