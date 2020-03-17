#!/usr/local_rwth/bin/zsh
 
### #SBATCH directives need to be in the first part of the jobscript

### Job name
#SBATCH --job-name=PaiJob

### Output path for stdout and stderr
### %J is the job ID, %I is the array ID
#SBATCH --output=output_%J.txt

### Request the time you need for execution. The full format is D-HH:MM:SS
### You must at least specify minutes OR days and hours and may add or
### leave out any other parameters
#SBATCH --time=3-00:00:00

### Request the amount of memory you need for your job.
### You can specify this in either MB (1024M) or GB (4G).

#SBATCH --nodes=1
#SBATCH --mem=40G
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1

### Request a host with a Volta GPU
### If you need two GPUs, change the number accordingly
#SBATCH --gres=gpu:pascal:2

### if needed: switch to your working directory (where you saved your program)
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

### Load modules
module switch intel gcc
module load python/3.6.8
module load cuda/100
module load cudnn/7.4
source ../compstatenv/bin/activate

python3 experiments/train/run_swag.py --data_path=cifar-100-python --epochs=300 --dataset=CIFAR100 --save_freq=300 --model=PreResNet164 --lr_init=0.1 --wd=3e-4 --swa --swa_start=161 --swa_lr=0.05 --cov_mat --use_test --dir=.

