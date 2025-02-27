#!/bin/bash
# Log rotation script that deletes lottery project logs older than a specified number of days

d_day=$1

if [ -z "$1" ]
  then
    d_day=7
fi

root_path=/root/
lottery_projects=$(ls $root_path | grep lottery)
last_day=$(date -d "-$d_day day" +%Y-%m-%d)


echo 'prepared to delete logs before:' $last_day

for project in ${lottery_projects[*]}
do
  echo '['$project'] logs delete ---------------------------------------------|';

  cd $root_path$project/logs/;

  rm all.$last_day.*.log && echo '['$project'] successful deleted all.log'

  rm error.$last_day.*.log && echo '['$project'] successful deleted error.log'

  cd ../agent/logs && rm skywalking-api.log.* && echo '['$project'] successful deleted skywalking.log'
done

exit 0