#!/bin/bash

# Handle command line args
DO_RESUB=1
while getopts ":o" opt; do
  case $opt in
    o)
     DO_RESUB=0 
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

NUM_JOBS_IN_QUEUE=`/opt/software/powertools/bin/sq | grep -P "\d+\s+Jobs\s+in\s+the\s+queue" -o | grep -P "\d+" -o`
TIMESTAMP=`date +%m_%d_%y__%H_%M_%S`
# Two-step process to get the path
ROLL_Q_PATH=`realpath "$0"` 
ROLL_Q_DIR=`dirname ${ROLL_Q_PATH}` 
echo "roll_q directory: ${ROLL_Q_DIR}"

echo "$NUM_JOBS_IN_QUEUE jobs currently in queue"
# Remove old continuation job if it exists
if [ -e ${ROLL_Q_DIR}/roll_q_resub_job.sb ]; then
    rm ${ROLL_Q_DIR}/roll_q_resub_job.sb
fi
python ${ROLL_Q_DIR}/roll_q.py $NUM_JOBS_IN_QUEUE $ROLL_Q_DIR $DO_RESUB
chmod a+x ${ROLL_Q_DIR}/roll_q_submit.sh
echo ""
echo "Here's the script:"
cat ${ROLL_Q_DIR}/roll_q_submit.sh
${ROLL_Q_DIR}/roll_q_submit.sh
mv ${ROLL_Q_DIR}/roll_q_submit.sh ${ROLL_Q_DIR}/roll_q_history/roll_q_submit_${TIMESTAMP}.sh
echo "Script saved at \"${ROLL_Q_DIR}/roll_q_history/roll_q_submit_${TIMESTAMP}.sh\""

# Launch timing jobs via roll_q!
echo "################"
if [ "${DO_RESUB}" == "1" ]; then
    echo "Checking continuation job!"
    echo "Run ./roll_q -o to skip continuation jobs!"
    if [ -e ${ROLL_Q_DIR}/roll_q_resub_job.sb ]; then
        sbatch ${ROLL_Q_DIR}/roll_q_resub_job.sb
        echo "Continuation job submitted!"
    fi
    if [ ! -e ${ROLL_Q_DIR}/roll_q_resub_job.sb ]; then
        echo "All jobs submitted, no continuation job submitted!"
    fi
fi
if [ "${DO_RESUB}" == "0" ]; then
    echo "Skipping continuation job!"
    echo "Run without -o to run a continuation job!"
    if [ -e ${ROLL_Q_DIR}/roll_q_resub_job.sb ]; then
        rm ${ROLL_Q_DIR}/roll_q_resub_job.sb
    fi
fi

