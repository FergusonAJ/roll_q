#!/bin/bash
NUM_JOBS_IN_QUEUE=`/opt/software/powertools/bin/sq | grep -P "\d+\s+Jobs\s+in\s+the\s+queue" -o | grep -P "\d+" -o`
TIMESTAMP=`date +%m_%d_%y__%H_%M_%S`
ROLL_Q_DIR=./ 

echo "$NUM_JOBS_IN_QUEUE jobs currently in queue"
python ${ROLL_Q_DIR}/roll_q.py $NUM_JOBS_IN_QUEUE
chmod a+x ${ROLL_Q_DIR}/roll_q_submit.sh
echo ""
echo "Here's the script:"
cat ${ROLL_Q_DIR}/roll_q_submit.sh
${ROLL_Q_DIR}/roll_q_submit.sh
mv ${ROLL_Q_DIR}/roll_q_submit.sh ${ROLL_Q_DIR}/roll_q_history/roll_q_submit_${TIMESTAMP}.sh
echo "Script saved at \"${ROLL_Q_DIR}/roll_q_history/roll_q_submit_${TIMESTAMP}.sh\""
