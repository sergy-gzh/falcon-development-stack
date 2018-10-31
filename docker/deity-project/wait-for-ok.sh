#!/usr/bin/env sh

################################################################
# simple script to poll a webpage until a HTTP 200 is returned
# depends on curl
#
#   parameter $1 url to call e.g. "http://www.google.com"
#   parameter $2 number of retries
#
#   improvement : url als last param, handle rest as options
#
#################################################################
 
if [ -z ${1+x} ] 
then 
    echo "parameter 1 is not set. please provide url";
    exit 1;
fi

maxCount=50
if [ "$2" -gt 0 ] 
then
   maxCount=$2
fi

let count=0;

while true
do
    httpResult="$(curl -s -o /dev/null -w ''%{http_code}''  $1)";
    let "count++";
    
    if [ "$httpResult" == "200" ]
    then
        echo "calling for '$1' attempt '$count' of '$maxCount' succeeded";
        exit 0
    else
        echo "calling for '$1' attempt '$count' of '$maxCount' faild with code '$httpResult'";
        if [ "$count" -ge $maxCount ]
        then 
            echo "exiting loop after '$maxCount' tries"; 
            exit 2; 
        fi 
        sleep 2;
    fi;
done;
