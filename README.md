# roll_q
A simple rolling queue for submitting large numbers of jobs to a slurm workload manager (In this case MSU's HPCC)

## Basic usage
This system _should_ be really simple to use! All steps can be done from the terminal without manually opening any files. 

Once you've downloaded the repo, navigate into the root roll_q directory and follow these steps:

1. Find the slurm job scripts
  * We want to collect the filenames of all the slurm job scripts we wish to start and put them in `roll_q_job_array.txt`
  * The UNIX `find` command can help! 
  * Note: It is critical we use absolute paths!
  * Basic example: ```find /mnt/scratch/users/austin/jobs/ -name *.sb > roll_q_job_array.txt```
  * Optionally sort the files ```find /mnt/scratch/users/austin/jobs/ -name *.sb | sort > roll_q_job_array.txt```
 
2. Reset the index
  * To keep track of where we are in the queue, roll_q saves of its current index in `roll_q_idx.txt`
  * If we've replaced the job array, we should reset the index back to 0!
  * From the command line: ```echo "0" > roll_q_idx.txt```
3. Launch the jobs!
  * Simple run `./roll_q.sh`

## Misc. notes
- roll_q will check slurm scripts to see if they are array jobs, and it will only queue files where _all_ the array jobs can start. 
  * e.g., if we have 50 free spots in our queue and the next script has 100 array jobs, it will _not_ start
- By default, slurm output will be written to the directory where `sbatch` was called (here the roll_q directory).
  * To avoid this, the job file will need to define the `--output` and `--error` slurm options
