#!/bin/bash
# Utility to extract and collect nginx log entries containing a specific phone number keyword

#change user nginx log file directory
LOG_PATH=/nginxlogs/

####
if [ -z "$1" ];then
    echo 'please append phone number ~!'
    exit 1
fi
echo 'start picking phone:'$1' from '$LOG_PATH

####
log_names=$(ls $LOG_PATH | grep access.log)
for log_name in ${log_names[*]}
do
  logs+=($log_name)
done

####
id=1
echo '-----choose file number for use, not choose means for all'
echo '  | '
for log in ${logs[*]}
do
  echo '  |-' $id ' -> pick from ' $log
  id=$(($id+1))
done

######
chos_logs=${logs[*]}
read chos
if [ -z "$chos" ];then
    chos_logs=${logs[*]}
elif [[ $chos == *'-'* ]];then
    start_index="$(echo $chos | cut -d '-' -f1)"
    end_index="$(echo $chos | cut -d '-' -f2)"

    if [ -z "$start_index" ];then
        start_index=1
    fi

    if [ -z "$end_index" ];then
        end_index=${#logs[@]}+1
    fi
    chos_logs=${logs[@]:$start_index-1:$end_index-$start_index+1}
else
    chos_logs=${logs[$chos-1]}
fi

####

mkdir $LOG_PATH'phone_picker' || echo 'ok'
mkdir $LOG_PATH'phone_picker/'$1 || echo 'ok'


OUT_PATH=($LOG_PATH'phone_picker/'$1'/')
FILE_NAME=($LOG_PATH'phone/'$1'/'$chos_log'_'`date +%y%m%d-%H:%M:%S`)
for file in ${chos_logs[*]}
do
  echo 'picking from:'$file
  cat $LOG_PATH$file | grep $1 >> $OUT_PATH$file
done


echo '.'
echo '.'
echo '-'
echo 'end pick phone:'$1
echo 'find result in '$OUT_PATH

exit 0