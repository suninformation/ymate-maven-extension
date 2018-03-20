#!/bin/bash
cd `dirname $0`
if [ "$1" = "start" ]; then
	./start.sh
else
	if [ "$1" = "stop" ]; then
		./stop.sh
	else
		if [ "$1" = "restart" ]; then
				./restart.sh
			else
                echo "usage: manager.sh [start|stop|restart]"
                exit 1
			fi
	fi
fi
