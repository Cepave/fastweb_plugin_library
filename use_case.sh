#!/bin/bash

#    local FILE_NAME=$1
#    local METRIC_NAME=$2
#    local ret_value=$3
#    local TAG_NAME=$4
#    local tag_value=$5

source ./library.sh

echo "first round"
stateful_output $(basename $0) http.log.error.5xx 1 Domain a.com.tw
echo "second round"
stateful_output $(basename $0) http.log.error.5xx 1 Domain b.com.tw
echo "third round"
stateful_output $(basename $0) http.log.error.5xx 0 Domain 
