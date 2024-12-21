#!/bin/bash

# Templates
npt_template="npt_Temp.mdp"
md_template="md_Temp_A.mdp"

# Arrays for temperatures and acceleration values
#temperatures=(300 325 350 375 400)  # Add more temperatures as needed
temperatures=(300)
#accelerations=(0.015 0.0125 0.01 0.0075 0.005 0.0035 0.0025)  # Add more accelerations as needed
accelerations=(0.015)

# Function to generate the new .mdp file with the specified temperature
generate_npt_mdp_file() {
    local temp=$1
    local new_file="npt_${temp}.mdp"
    
    # Replace "Temp" with the actual temperature value in the new file
    sed "s/Temp/${temp}/g" $npt_template > $new_file
    
    echo "Generated ${new_file}"
}

# Function to generate the new .mdp file with the specified temperature and acceleration
generate_md_mdp_file() {
    local temp=$1
    local acc=$2
    local new_file="md_${temp}_${acc}.mdp"
    
    # Replace "Temp" with the actual temperature and "A" with the actual acceleration value in the new file
    sed "s/Temp/${temp}/g; s/A/${acc}/g" $md_template > $new_file
    
    echo "Generated ${new_file}"
}

# Generate npt_Temp.mdp files
for temp in "${temperatures[@]}"; do
    generate_npt_mdp_file $temp
done

# Generate md_Temp_A.mdp files
for temp in "${temperatures[@]}"; do
    for acc in "${accelerations[@]}"; do
        generate_md_mdp_file $temp $acc
    done
done


# Loop over different temperatures
for T in "${temperatures[@]}"; do
# NPT 2 ns @T
gmx grompp -f npt_${T}.mdp -c mini.gro -r mini.gro -p topol.top -o npt_${T}.tpr -maxwarn 1
gmx mdrun -v -nt 12 -deffnm npt_${T}

	# Loop over different shear rates
	for A in "${accelerations[@]}"; do
		# 1 ns NEMD simulation
		gmx grompp -f md_${T}_${A}.mdp -c npt_${T}.gro -t npt_${T}.cpt -p topol.top -o NEMD_${T}_${A}.tpr -maxwarn 5
		gmx mdrun -v -nt 12 -deffnm NEMD_${T}_${A}

	done
done 

