#!/bin/bash

# Directory setup - fixed paths based on your structure
PROJECT_DIR="verimoog_1_7"
SRC_DIR="${PROJECT_DIR}/verimoog_1_7.srcs/sources_1/imports/new"
TB_IMPORTS="${PROJECT_DIR}/verimoog_1_7.srcs/sim_1/imports/new"
TB_NEW="${PROJECT_DIR}/verimoog_1_7.srcs/sim_1/new"
WAVES_DIR="waveforms"

# Create waveforms directory
mkdir -p $WAVES_DIR

# Function to compile and run testbench
run_testbench() {
    local tb_file="$1"
    local src_file="$2"
    local tb_name=$(basename "$tb_file" _tb.v)

    echo "Processing testbench: $tb_name"
    echo "Source file: $src_file"
    echo "Testbench file: $tb_file"

    # Compile the testbench and source file
    if iverilog -o "${WAVES_DIR}/${tb_name}.vvp" "$tb_file" "$src_file"; then
        echo "Compilation successful"

        # Run the simulation
        vvp "${WAVES_DIR}/${tb_name}.vvp"

        # Create gtkwave script
        cat > "${WAVES_DIR}/${tb_name}.tcl" << EOL
set vcd_file [gtkwave::getBaseDirectory]/${tb_name}_tb.vcd
gtkwave::/File/New
gtkwave::/File/Open_New_Tab \$vcd_file

# Add all signals
set nfacs [ gtkwave::getNumFacs ]
set all_facs [list]
for {set i 0} {\$i < \$nfacs } {incr i} {
    set facname [ gtkwave::getFacName \$i ]
    lappend all_facs "\$facname"
}
set num_added [ gtkwave::addSignalsFromList \$all_facs ]

# Zoom full
gtkwave::/Time/Zoom/Zoom_Full

# Save image
gtkwave::/File/Export/Write_PNG_Image ${WAVES_DIR}/${tb_name}_waves.png

# Exit gtkwave
gtkwave::/File/Quit
EOL

        # Run gtkwave in script mode
        gtkwave -S "${WAVES_DIR}/${tb_name}.tcl" "${WAVES_DIR}/${tb_name}_tb.vcd"

        echo "Generated waveform for $tb_name"
        echo "----------------------------------------"
    else
        echo "Failed to compile $tb_name"
        echo "----------------------------------------"
    fi
}

echo "Starting testbench processing..."

# Process testbenches from imports/new
for tb in $TB_IMPORTS/*_tb.v; do
    if [ -f "$tb" ]; then
        base_name=$(basename "$tb" _tb.v)
        src_file="$SRC_DIR/${base_name}.v"
        if [ -f "$src_file" ]; then
            run_testbench "$tb" "$src_file"
        else
            echo "Source file not found: $src_file"
        fi
    fi
done

# Process testbenches from new
for tb in $TB_NEW/*_tb.v; do
    if [ -f "$tb" ]; then
        base_name=$(basename "$tb" _tb.v)
        src_file="$SRC_DIR/${base_name}.v"
        if [ -f "$src_file" ]; then
            run_testbench "$tb" "$src_file"
        else
            echo "Source file not found: $src_file"
        fi
    fi
done

echo "All testbenches processed. Waveforms saved in $WAVES_DIR"
