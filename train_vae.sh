#!/bin/bash
#--------------------------------------------------------------------------------
#  SBATCH CONFIG
#--------------------------------------------------------------------------------
#SBATCH --job-name=trainvae            # name for the job
#SBATCH -N 1                           # number of nodes
#SBATCH --tasks-per-node=1             # number of cores
#SBATCH --mem=16G                      # total memory
#SBATCH --time 2-00:00                 # time limit in the form days-hours:minutes
#SBATCH --mail-user=zwhkv@umsystem.edu # email address for notifications
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --partition gpu        # use partition Gpu
#SBATCH --gres gpu:A100           # request generic GPU resources
#--------------------------------------------------------------------------------

export OMP_NUM_THREADS=1
export KMP_AFFINITY=disabled

echo "### Starting at: $(date) ###"
module purge
module load miniconda3
source activate cmdstanr

## Run script
echo
echo "### Starting with $n_workers worker ###"
~/.conda/envs/cmdstanr/bin/Rscript ~/data/Workspace/VMSAE_resources/train_vae.r
echo "### Ending with $n_workers worker ###"
echo
conda deactivate
echo "### Ending at: $(date) ###"
