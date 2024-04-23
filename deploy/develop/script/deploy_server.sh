# (1)
REPOSITORY=/home
BUILD_PATH=$(ls -tr ${REPOSITORY}/build/lib/*.war | tail -1)
WAR_NAME=$(basename $BUILD_PATH)
echo "> build file: $WAR_NAME"

# (2)
echo "> copy build file"
DEPLOY_PATH=${REPOSITORY}/deploy/
if [ ! -d $DEPLOY_PATH ]; then
  mkdir $DEPLOY_PATH
fi

cp $BUILD_PATH $DEPLOY_PATH

echo "> change file name"
CP_WAR_PATH=$DEPLOY_PATH$WAR_NAME
APPLICATION_WAR_NAME=ROOT.war
APPLICATION_WAR=$DEPLOY_PATH$APPLICATION_WAR_NAME

echo "> create link"
ln -Tfs $CP_WAR_PATH $APPLICATION_WAR

# (3)
echo "> Check application PID."
CURRENT_PID=$(pgrep -f -n $APPLICATION_WAR_NAME)
echo "$CURRENT_PID"

if [ -z $CURRENT_PID ];
  then
    echo "> No running applications found."
else
	echo "> kill -9 $CURRENT_PID"
	kill -9 $CURRENT_PID
	sleep 10
fi

# (4)
echo "> Run application."
nohup java -bootWar -Dspring.profiles.active=prod $APPLICATION_WAR > /dev/null 2> /dev/null < /dev/null &