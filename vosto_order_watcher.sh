#!/usr/bin/env bash

PIDFILE="/usr/share/vosto_order/current/goliath.pid"

pidVar=`cat /usr/share/vosto_order/current/goliath.pid`

kill -9  $pidVar
exit 99
