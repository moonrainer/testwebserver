#!/bin/bash

export DISPLAY=:0.0
export TREMOLO_ROOT="/usr/local/tremolo/tremolo-service"
export TREMOLO_HOME="$TREMOLO_ROOT/external"
export TREMOLO_PROXY_HOME="$TREMOLO_HOME/apps/proxy"
export TREMOLO_ADMIN_HOME="$TREMOLO_HOME/apps/tremolo-admin"
export TREMOLO_WS_HOME="$TREMOLO_HOME/apps/webservices"
export TREMOLO_SSH_KEYS="$TREMOLO_ROOT/.ssh"
export TREMOLO_QUARTZ_DIR="$TREMOLO_HOME/conf/quartz"
export TREMOLO_LOG="$TREMOLO_HOME/logs/tremolo.log"
export TREMOLO_ACTIVEMQ="$TREMOLO_HOME/activemq"
export TREMOLO_EXTERNAL="$TREMOLO_HOME/ext-lib"


JAVA_CMD=`which java`
if [ ! $JAVA_CMD ]; then
  echo -e "Java could not be found. Please install Java and try again.\n"
  exit 1
fi

export CLASSPATH=$TREMOLO_HOME/conf:$CLASSPATH:$TREMOLO_ROOT/libs/*:$TREMOLO_ROOT/jars/*:$TREMOLO_HOME/ext-lib/*:$TREMOLO_QUARTZ_DIR

TREMOLO_CMD="$JAVA_CMD -Dorg.eclipse.jetty.server.Request.maxFormContentSize=-1 -Dcom.tremolosecurity.openunison.activemqdir=$TREMOLO_ACTIVEMQ -Dcom.tremolosecurity.openunison.quartzdir=$TREMOLO_QUARTZ_DIR $JAVA_OPTS -server com.tremolosecurity.server.Server"



echo "Starting Unison..."
exec $TREMOLO_CMD 2>&1
