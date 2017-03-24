#!/bin/bash

#ret_value=1
#tag_value="a.com.tw"
#TAG_NAME="Domain"
#METRIC_NAME="http.log.error.5xx"
#FILE_NAME="qqqqqqq.sh"

function stateful_output() {
    local FILE_NAME=$1
    local METRIC_NAME=$2
    local ret_value=$3
    local TAG_NAME=$4
    local tag_value=$5

    local tmp_file=/tmp/$FILE_NAME.cumulated
    local target_file=/tmp/$FILE_NAME.once


    if [ $ret_value -eq 0 ]; then
        echo "$TAG_NAME=$tag_value  $METRIC_NAME  0   \n" >> $tmp_file
        target_file=$tmp_file
    else
        echo "$TAG_NAME=$tag_value  $METRIC_NAME  0   \n" >> $tmp_file
        echo "$TAG_NAME=$tag_value  $METRIC_NAME  $ret_value \n" > $target_file
    fi

    s='{"endpoint":"%s","timestamp":%s,"tags":"%s","metric":"%s","value":%s,"counterType":"GAUGE","step":60}\n'
    rowCount=$(cat $target_file | wc -l)
    cat $target_file \
    | awk -v hostname="$(hostname -s)" -v date="$(date +%s)" '{print hostname, date, $0}' \
    | awk -v format=$s '{printf(format,$1,$2,$3,$4,$5) }' \
    | awk -v size=$rowCount 'BEGIN{print "["}{if(NR<size){print $0","} else {print $0}}END{print "]"}'

    # reset the cache
    if [ $ret_value -eq 0 ]; then
        cat /dev/null > $tmp_file
    fi
}
