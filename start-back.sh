#!/usr/bin/env bash

function get-script-dir {
    # Resolve possible symlinks to script file
    src=$0
    while [ -h "$src" ]; do
        dir=$(cd -P "$(dirname "$src")" && pwd)
        src=$(readlink "$src")
        # If it's not an absolute path, then append it
        if [[ $src != /* ]]; then
            src=$dir/$src
        fi
    done

    # Get the full traversal required
    dir=$(cd -P "$(dirname "$src")" && pwd)
    echo "$dir"
}

# Get the directory
scriptdir=$(get-script-dir)
tsgbackenddir="$scriptdir/tsg3macroservice"
tsgdbdir="$scriptdir/db"

#tsgclientidpath="$scriptdir/client-id.txt"
#tsgclientsecretpath="$scriptdir/client-secret.txt"

#if [ ! -f "$tsgclientidpath" ]; then
#    echo "ERROR: Missing client-id.txt at $tsgclientidpath"
#    echo "You will need to set up a Google Oauth client at the Google Cloud Dashboard."
#    exit 1
#fi

#export GOOGLE_CLIENT_ID=$(cat "$tsgclientidpath")

#if [ ! -f "$tsgclientsecretpath" ]; then
#    echo "ERROR: Missing client-secret.txt at $tsgclientsecretpath"
#    echo "You will need to set up a Google Oauth client at the Google Cloud Dashboard."
#    exit 1
#fi

#export GOOGLE_CLIENT_SECRET=$(cat "$tsgclientsecretpath")

logpath=$(pwd)

# Go into the database directory
cd $tsgdbdir
# Start the database
if [ -z $1 ]; then
    echo "Running without log file"
    docker compose up
else
    logfile="$logpath/$1"
    if [ -f $logfile ]; then
        rm $logfile
    fi
    docker compose up > >(tee -a $logfile) 2>&1
fi
