#
# Written by: Tung Tran (Github ID: tungtns)
# Version: 1.0 beta
# License: LGPL
# Release date: Jan 28th 2015
#
#!/bin/bash

USR_NAME=${USER}
PROD_BASEDIR="/opt/exo/platform-community-4.1.0"
ADM_LOG_DIR="${PROD_BASEDIR}/logs"
PRJ_NAME="PLF"

echo "[INFO] Start ${PRJ_NAME} tomcat ..."
if [ -f ${PROD_BASEDIR}/start_eXo.sh ]; then
        if [ -f "${ADM_LOG_DIR}/platform.log" ]; then
                rm -rf ${ADM_LOG_DIR}/platform.log
        fi
	${PROD_BASEDIR}/start_eXo.sh -b > /dev/null 2>&1
        echo -n "[INFO] Waiting for the availability of tomcat Logs..."
        while [ true ];
        do
                if [ -f "${ADM_LOG_DIR}/platform.log" ]; then
                        break
                fi
                echo -n "."
                sleep 1
        done
        echo -n " OK"
        echo ""
        tail -f ${ADM_LOG_DIR}/platform.log &
        tail_PID=$!
        # Check if startup sign exists
        set +e
        while [ true ];
        do
                if grep -q "Server startup in" ${ADM_LOG_DIR}/platform.log; then
                        kill ${tail_PID}
                        wait ${tail_PID} 2> /dev/null
			break
                fi
        done
	echo "[INFO] Tomcat successfully started. Stop it..."
        ${PROD_BASEDIR}/stop_eXo.sh -force
	echo "[INFO] Tomcat successfully stopped."
        set -e
else
        echo "[ERROR] ${PRJ_NAME} does not exist. Unable to start."
fi
echo "[INFO] Done"
