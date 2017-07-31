#!/bin/bash

#------------------------------------------------------------------------------
# M A I N
#------------------------------------------------------------------------------

APP=$0

if ! test -d "$1"; then
	_syntax "[container/image] [build|start|stop]\n\nDOCKER_NAME=MyContainer ./run.sh ubuntu/xenial start" 
fi

. $1/config.sh

if test -z "$DOCKER_IMAGE"; then
	DOCKER_IMAGE=`echo "$1" | sed -e 's#[/ ]#_#g'`
fi

if test -z "$DOCKER_NAME"; then
	DOCKER_NAME="rk_$DOCKER_IMAGE"
fi


echo

case $2 in
build)
	echo -e "docker build -t rk:$DOCKER_IMAGE $1\nYou might need to type in root password\n"
	docker build -t rk:$DOCKER_IMAGE $1
	;;
start)
	if ! test -z "$STOP_HTTP"; then
		_stop_http
	fi

	_docker_rm $DOCKER_NAME

	echo "docker run $DOCKER_RUN --name $DOCKER_NAME rk:$DOCKER_IMAGE"
	docker run $DOCKER_RUN --name $DOCKER_NAME rk:$DOCKER_IMAGE
	;;
stop)
	_docker_stop $DOCKER_NAME
	;;
*)
	_syntax "container/image [build|start|stop]"
esac

echo

