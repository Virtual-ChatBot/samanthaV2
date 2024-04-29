#deploy.sh
HOME=/home/samantha/tomcat_data
WAR_NAME=ROOT.war
WAIT_TIME=10
echo "> build 파일명: $WAR_NAME"

#Jenkins 환경 변수에서 전달한 값
DOCKER_PASSWORD=$1
SERVER_IP=$2
PROD_PORT=$3
SERVER_LIST=$4

#스크립트 내에서 변수 사용
echo "Docker Password: $DOCKER_PASSWORD"
echo "Server IP: $SERVER_IP"
echo "Prod Port: $PROD_PORT"
echo "Server List: $SERVER_LIST"

# 서버 health 체크 함수
check_server_health() {
    local retry_count=0
    while [ $retry_count -lt $MAX_RETRY ]; do
        response=$(curl -s --max-time 10 http://$SERVER_IP:$PROD_PORT/actuator/health)
        up_count=$(echo $response | grep -o 'UP' | wc -l)
        echo "> Retry: $((retry_count+1)), Response: $response, UP Count: $up_count"

        if ! [[ "$up_count" =~ ^[0-9]+$ ]]; then
            echo "> 서버 health 체크 오류: UP Count가 숫자가 아닙니다."
            ((retry_count++))
            continue
        fi

        if [ $up_count -ge 1 ]; then
            echo "> 서버 health 체크 성공"
            return 0
        fi
        echo "> 실패. 재시도 대기 중..."
        sleep $WAIT_TIME
        ((retry_count++))
    done
    echo "> 서버 health 체크 실패"
    return 1
}

#===================================생존 서버 확인=====================================
echo "> 서버 체크 시작"
check_server_health || exit 1

#===================================프로세스 종료======================================
echo "> 구동중인 애플리케이션 확인"
if [ $(curl -s --max-time 10 http://$SERVER_IP:$PROD_PORT/actuator/health | grep 'UP' | wc -l) -eq 0 ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 서버 종료하지 않습니다."
else
    echo "> [$SERVER_LIST] 서버를 재시작합니다."
    echo $DOCKER_PASSWORD | sudo -S docker restart $SERVER_LIST
    loop=1
    while [ $loop -le $WAIT_TIME ]; do
        if check_server_health; then
            echo "> 성공적으로 서버를 재시작하였습니다."
            break
        else
            echo "> [$loop/$WAIT_TIME] $SERVER_LIST 서버 종료를 기다리는 중입니다."
            sleep 1
            ((loop++))
        fi
    done
    if [ $loop -gt $WAIT_TIME ]; then
        echo "> 서버 종료를 기다리는 동안 시간이 초과되었습니다. 강제 종료를 시도합니다."
        echo $DOCKER_PASSWORD | sudo -S docker restart $SERVER_LIST
    fi
fi