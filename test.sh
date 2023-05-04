test.sh
#!/bin/bash

. ./.env

while true
do
  DATE=`date +%Y-%m-%d`
  DAY_OF_WEEK=`date +%a`
  DAY_OF_MONTH=`date +%d`

  # Loop through each job in the configurations.json file
  for row in $(jq -r '.[] | @base64' configurations.json); do
    # Decode each row from base64


    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }

    job_name=$(_jq '.job_name')
    period=$(_jq '.period')
    hour=$(_jq '.hour')
    configurations=$(_jq '.configurations')

    # Check if job should be run today
    if [[ $period == "daily" ]]; then
      run_job=true
    elif [[ $period == "weekly" && $DAY_OF_WEEK == ${hour:0:3} ]]; then
      run_job=true
    elif [[ $period == "monthly" && $DAY_OF_MONTH == ${hour:0:2} ]]; then
      run_job=true
    else
      run_job=false
    fi

    #sending data as jason to scheduler.py



    #run scheduler.py based on the value of rub_job
    cat configurations.json | python scheduler.py -

    python scheduler.py run_job;

    : 'Run job if it should be run today
    if [[ $run_job == true ]]
    then

      #context=$(get_contexte $configurations)
      # Call script or command to run the job with the context message
      #echo "Running job $job_name with context message: $context"
      # Replace the echo statement above with the command to run the job
    fi

  done'

  # Sleep for 1 hour before checking again
  sleep 1h

done