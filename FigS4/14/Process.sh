#!/bin/bash
# Define arrays for T and A values
T_values=(300 325 350 375 400)
A_values=(0.015 0.0125 0.01 0.0075 0.005 0.0035 0.0025)

# Function to check if file exists
file_exists() {
    local filename="$1"
    [ -f "$filename" ]
}

# Loop over each combination of T and A
for T in "${T_values[@]}"; do
    for A in "${A_values[@]}"; do
        # Construct file names
        filename_base="NEMD_${T}_${A}"
        gro_file="${filename_base}.gro"

        # Check if .gro file exists (meaning the simulation is successfully done)
        if file_exists "$gro_file"; then
            # Run gmx energy command with heredoc
            gmx energy -f "${filename_base}.edr" -s "${filename_base}.tpr" -o "${filename_base}.xvg" << EOF
38   # Vikas, please check the number here for density, sometime it is "39", NOT "38"
$(echo -e "\n")
EOF
        else
            echo "Skipping ${filename_base}: ${gro_file} not found"
        fi
    done
done
