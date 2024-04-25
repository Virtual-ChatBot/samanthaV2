HOME=/home/samantha/tomcat_data
WAR_NAME=ROOT.war
WAIT_TIME=1

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

echo "> change file name for prod1"
CP_WAR_PATH_PROD1=$DEPLOY_PATH_PROD1$WAR_PATH_PROD1
APPLICATION_WAR_PROD1=$DEPLOY_PATH_PROD1$WAR_NAME

echo "> create link for prod1"
ln -Tfs $CP_WAR_PATH_PROD1 $APPLICATION_WAR_PROD1

# (1.3)
echo "> Check application PID for prod1."
CURRENT_PID_PROD1=$(pgrep -f -n $WAR_NAME)
echo "$CURRENT_PID_PROD1"

if [ -z $CURRENT_PID_PROD1 ]; then
    echo "> Restarting Docker container for prod1"
    echo "Qkrdydclf12" | sudo -S docker restart prod1
    sleep $WAIT_TIME
fi

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

echo "> change file name for prod2"
CP_WAR_PATH_PROD2=$DEPLOY_PATH_PROD2$WAR_PATH_PROD2
APPLICATION_WAR_PROD2=$DEPLOY_PATH_PROD2$WAR_NAME

echo "> create link for prod2"
ln -Tfs $CP_WAR_PATH_PROD2 $APPLICATION_WAR_PROD2

# (2.3)
echo "> Check application PID for prod2."
CURRENT_PID_PROD2=$(pgrep -f -n $WAR_NAME)
echo "$CURRENT_PID_PROD2"

if [ -z $CURRENT_PID_PROD2 ]; then
    sleep $WAIT_TIME
    echo "> Restarting Docker container for prod2"
    echo "Qkrdydclf12" | sudo -S docker restart prod2
fi