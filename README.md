# IMAT Machine Learning Modelling for Materials Science

 Instructions for the IMAT Training Programme MT Wk 6, University of Oxford
 &copy; Daniel Thomas du Toit 2024

## Introduction

Machine Learning Interatomic Potentials (MLPs) are often used to approximate quantum mechanical calculations in materials science. Over the next week, you will be learning why MLPs are useful, and shown examples of how they are used in materials science to elucidate important characteristics of materials and explain structure -- property relationships.

This repository contains a series of files that instruct you on using machine learning to simulate the sudden quenching of carbon. The notebooks are designed to be used in the IMAT training programme, but can be used by anyone interested in learning about using MLPs in materials science.

## Setting Up

Terms to get familiar with:
- **ARC**: Advanced Research Computing, the computing cluster at the University of Oxford. This is where you will be running your simulations.
- **LAMMPS**: Large-scale Atomic/Molecular Massively Parallel Simulator, a classical molecular dynamics code that you will be using to model carbon.
- **ACE**: Atomistic Cluster Expansion, a Machine Learning architecture that your model will use to predict the dynamics of carbon.
- **OVITO**: A visualisation software that you will use to visualise the structures you generate, and perform analysis for your presentation.

### Accessing ARC

You have been given accounts with which to access ARC, the University of Oxford HPC cluster. You can access ARC by using the following command in your terminal:
```bash
ssh <username>@arc-login.arc.ox.ac.uk
```
You will be required to then enter your password. This will give you access to the cluster.

ARC has two main file systems: `$HOME`, and `$DATA`. The `$HOME` directory has a very small filesize limit, while the `$DATA` directory has a much larger limit. As such, we will store everything in the `$DATA` directory. After logging in, do the following to explore your directories.

```bash
# After logging in, you will be in $HOME
pwd
>>> /home/<username>
cd $DATA
# You are now in the $DATA directory
pwd
>>> s/data/.../<username>
```

To copy the relevant files, including this instruction manual, to your ARC account, you must use the following command:
```bash
git clone https://github.com/dft-dutoit/imat-machine-learning.git
cd imat-machine-learning
ls
# This command shows the files and folders in the current directory
lammps-md README.md LICENSE
```

You are now ready to start modelling carbon! Let's run a quick test to make sure that the LAMMPS executable is working as expected.

You are currently on the **login node**. This is where you submit jobs from, or explore file structures etc. In order to run simulations, you need to connect to a **compute node**. This requires us to request the requisite resources. We will be using the `srun` command to do this. The following command will request 1 CPU node (40 cores) for 4 hours. 

```bash
srun --nodes=1 --ntasks-per-node=40 --time=04:00:00 --pty /bin/bash
```
Now, instead of `username@arc-login`, you will see `username@arc-cXXX` in your bash prompt. This means you are on a compute node.

```bash
cd $DATA/imat-machine-learning/lammps-md/test-run
bash compile-lammps.sh
source ../prep.sh
mpiexec -np 16 lmp -in test.in
```
If the simulation works, you should get an output with a timing breakdown at the end. If you get an error, please let us know. Each time you connect to the compute node, you will need to run `source prep.sh` before you start LAMMPS simulation, as it loads the required dependencies for the program.

You are now set up on ARC.

### Setting Up OVITO

OVITO is a visualisation software that you will use to visualise the simulations during the workshop. You can download OVITO from [here](https://www.ovito.org/download/). You will need to download the free version of OVITO. Once you have downloaded OVITO, you can install it on your local machine. 

Once OVITO is installed on your local machine, we need to check whether we can see what we expect from a structure. Let's make sure you can visualise structures from ARC. There are two options to do this, and you can try either (or both).

1. **Directly from ARC**: You can use the cloud download button in OVITO to directly download the file over `scp` from ARC.

2. **Download to local machine**: You can download the file to your local machine, and then open it in OVITO. You can use the following command to download the file to your local machine:
```bash
>>> scp <username>@arc-login.arc.ox.ac.uk:$DATA/imat-machine-learning/lammps-md/test-run/trajectory.dat .
```

This should now show the structure in OVITO. At this time, it will only show the atoms, and not any bonds. This is because your simulation output does not contain bonding information, but rather, only atomic positions. To further analyse your structures, here are some of the most commonly used OVITO modifiers:

- **Colour Coding**: This modifier allows you to colour atoms based on a property. This is useful for visualising the distribution of properties in your structure. In your output file, the c_peratom property is the predicted energy of each atom, so you can see which atoms are higher or lower energy at a glance.

- **Create Bonds**: This modifier creates bonds between atoms based on a cutoff distance. This is useful for visualising the connectivity of atoms in your structure, and identify structural motifs

- **Coordination Analysis**: This modifier calculates the coordination number of each atom in your structure. This is useful for identifying the local environment of atoms in your structure. The cutoff here needs to be set to a value that is appropriate for your system, for Carbon, this would be $\approx1.85~\mathrm{\AA}$. 

- **Identify Diamond Structure**: This modifier identifies the diamond structure in your system. This can be useful for identifying the presence of diamond atomic environments and their type in your quenched structures.

## THURSDAY: Workshop Tasks

First, you will need to run the following commands, in this order, to prepare for running simulations:

```
srun --nodes=1 --ntasks-per-node=40 --time=04:00:00 --pty /bin/bash
cd $DATA/imat-machine-learning/lammps-md/test-run
source ../prep.sh
mpiexec -np 4 lmp -in in.lammps
```
This should result in a short simulation output. If it does not, please ask Bianca what to do next! After this, return to the OVITO instructions above to quickly check that you can visualise the structure of your material.


1. Make sure you can run the basic input in the folder `your-sim`. After running the existing simulation file, check the trajectory in OVITO and consider what you think will change if you change any of the following properties: Number of steps to quench, density of the initial structure, number of atoms in the cell.
2. Now that you've run your first LAMMPS simulations, you can edit the input file, and study the structures which you generate as a result, considering how changes to the input affect the resulting structures.
3. Prepare a short presentation (couple of slides) for Thursday afternoon to present the study that you completed on these small-scale cells. Try to make sure that no two people do *exactly the same* analysis.
