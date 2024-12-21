#!/bin/bash
rm topol.top
# Copy topotogy file
cp *.top topol.top
cp *.pdb mono.pdb

# Generate the box
gmx editconf -f mono.pdb -o newbox.gro -box 7.0 7.0 21.0 -center 3.5 3.5 10.5 #9.6 19.2
#gmx editconf -f mono.pdb -o newbox.gro -box 6.8 6.8 20.4 -center 3.4 3.4 10.2

# Read the PDB file
pdb_file="mono.pdb"
topol_file="topol.top"

# Extract the last line starting with "ATOM" and get the atom number
last_atom_line=$(grep "^ATOM" "$pdb_file" | tail -n 1)
num_atom_per=$(echo "$last_atom_line" | awk '{print $2}')

# Output the result
echo "The number of atoms per molecule is: $num_atom_per"

# Calculate the number of molecules to insert
num_molecules=$(echo "scale=0; 60000 / $num_atom_per" | bc)

# Output the number of molecules to insert
echo "The number of molecules to insert is: $num_molecules"

# Insert ~60,000 atoms of this molecule
# Read number of atoms per molecule from pdb file
gmx insert-molecules -f newbox.gro -ci mono.pdb -o dopc-mol.gro -try 1000 -nmol $((num_molecules-1))


# Add number of inserted molecules to the topol.top file
echo "Other       $((num_molecules-1))" >> "$topol_file"

# Run minimization
gmx grompp -f mini.mdp -c dopc-mol.gro -p topol.top -o mini.tpr -maxwarn 5
gmx mdrun -v -nt 12 -deffnm mini
