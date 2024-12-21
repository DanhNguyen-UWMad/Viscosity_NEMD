# Viscosity_NEMD
This GitHub demonstrates how to perform an NEMD simulation to calculate the viscosity of materials with GROMACS.

Simulation procedure by Danh Nguyen, UW-Madison (https://scholar.google.com/citations?user=1XY-fyQAAAAJ&hl=en)

1. Generate mol2 file from pdb file, using Avogadro or Material Studio.
2. Upload your mol2 file to https://app.cgenff.com/homepage to generate input files for GROMACS.
3. The input files generated from this website will include a folder of charmm36 force field, a pdb file, and a topology (top) file.
4. Once you have these files, you can run my bash script to generate a simulation box and perform minimization: 
./TopoGen_Mini.sh
5. Once your system is well built, then we can run 1ns-NPT and 1ns-NEMD NVT later, using this bash script (this one is used for different temperatures and A values, so please modify it if you want): 
./Final_run.sh
6. Once we finish the run, we will get the result from gmx energy command using this bash script. However, the results derived from GROMACS are NOT viscosity, it is the inverse value of viscosity (1/Viscosity): 
./Process.sh
7. Finally, I have a jupyter notebook to get the viscosity from the output files received in step 5 and then fit the MD data to get the zero-shear viscosity. The file is named 
CalculateVis_Fitting.ipynb


How to check density of simulation box after NPT run in GROMACS, for example:

gmx energy -f npt_300.edr -s npt_300.tpr -o den_300.xvg

How to extract the viscosity at A = 0.015 nm/ps2 after NEMD run in GROMACS, for example:

gmx energy -f NEMD_300_0.015.edr -s NEMD_300_0.015.tpr -o Vis_300_0.015.xvg

=> Notice that the result will be "1/viscosity"
