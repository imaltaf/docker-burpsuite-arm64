#!/usr/bin/env bash
set -ex

# Set the command to start Burp Suite
START_COMMAND="/bin/bash /burpsuite/run_burp.sh"
PGREP="java"  # Assuming the Burp Suite process is named 'java'

export MAXIMIZE="true"
export MAXIMIZE_NAME="Burp Suite"
MAXIMIZE_SCRIPT=$STARTUPDIR/maximize_window.sh
DEFAULT_ARGS=""
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

kasm_exec() {
    if [ -n "$OPT_URL" ] ; then
        URL=$OPT_URL
    fi 

    # Since we are execing into a container that already has the application running from startup, 
    # when we don't have a URL to open, we want to do nothing. Otherwise, a second instance would open. 
    if [ -n "$URL" ] ; then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready
        bash ${MAXIMIZE_SCRIPT} &
        $START_COMMAND $ARGS $OPT_URL
    else
        echo "No URL specified for exec command. Doing nothing."
    fi
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] ; then
        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -x $PGREP > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                set +e
                bash ${MAXIMIZE_SCRIPT} &
                $START_COMMAND $ARGS $URL
                set -e
            fi
            sleep 1
        done
        set -x
    fi
} 

# Check if the script should execute or startup
if [ -n "$GO" ] ; then
    kasm_exec
else
    kasm_startup
fi
