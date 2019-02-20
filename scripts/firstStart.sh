#!/bin/bash

if [ ! -d "/usr/local/tremolo/tremolo-service/external/apps" ] ; then
  echo "Copying apps"
  cp -r /usr/local/tremolo/tremolo-service/apps /usr/local/tremolo/tremolo-service/external/
fi

if [ ! -d "/usr/local/tremolo/tremolo-service/external/conf" ] ; then
  echo "Copying config"
  cp -r /usr/local/tremolo/tremolo-service/conf /usr/local/tremolo/tremolo-service/external/
fi

if [ ! -d "/usr/local/tremolo/tremolo-service/external/logs" ] ; then
  echo "Creating logs dir"
  mkdir /usr/local/tremolo/tremolo-service/external/logs
fi

if [ ! -d "/usr/local/tremolo/tremolo-service/external/ext-lib" ] ; then
  echo "Creating logs dir"
  mkdir /usr/local/tremolo/tremolo-service/external/ext-lib
  mv /tmp/drivers/*.jar /usr/local/tremolo/tremolo-service/external/ext-lib
  rm -rf /tmp/drivers
fi

#make sure we are updating the admin pages
rm -rf /usr/local/tremolo/tremolo-service/apps/tremolo-admin/WEB-INF
cp -rf /usr/local/tremolo/tremolo-service/apps/tremolo-admin/* /usr/local/tremolo/tremolo-service/external/apps/tremolo-admin/


exec /usr/local/tremolo/tremolo-service/bin/startUnisonInDocker.sh
