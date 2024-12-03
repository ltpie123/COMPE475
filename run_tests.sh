#!/bin/bash

# Directory setup
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

    # Create list of all required source files
    local src_files=()
    src_files+=("$src_file")

    # Add dependencies based on module
    case $tb_name in
        "synth")
            src_files+=("$SRC_DIR/midi_to_freq.v")
            src_files+=("$SRC_DIR/wav_selector.v")
            src_files+=("$SRC_DIR/adsr_envelope.v")
            ;;
        "wav_selector")
            src_files+=("$SRC_DIR/sqr_wav_gen.v")
            src_files+=("$SRC_DIR/sin_wav_gen.v")
            src_files+=("$SRC_DIR/saw_wav_gen.v")
            src_files+=("$SRC_DIR/tri_wav_gen.v")
            ;;
        "top")
            src_files+=("$SRC_DIR/midi_input.v")
            src_files+=("$SRC_DIR/synth.v")
            src_files+=("$SRC_DIR/pwm_audio.v")
            src_files+=("$SRC_DIR/midi_to_freq.v")
            src_files+=("$SRC_DIR/wav_selector.v")
            src_files+=("$SRC_DIR/adsr_envelope.v")
            src_files+=("$SRC_DIR/sqr_wav_gen.v")
            src_files+=("$SRC_DIR/sin_wav_gen.v")
            src_files+=("$SRC_DIR/saw_wav_gen.v")
            src_files+=("$SRC_DIR/tri_wav_gen.v")
            ;;
    esac

    # Compile with all dependencies
    if iverilog -o "${WAVES_DIR}/${tb_name}.vvp" "$tb_file" "${src_files[@]}"; then
        echo "Compilation successful"

        # Run simulation
        vvp "${WAVES_DIR}/${tb_name}.vvp"

        # Generate gtkwave script for capturing image
        cat > "${WAVES_DIR}/${tb_name}_capture.tcl" << EOL
set nfacs [ gtkwave::getNumFacs ]
set all_facs [list]
for {set i 0} {\$i < \$nfacs } {incr i} {
    set facname [ gtkwave::getFacName \$i ]
    lappend all_facs "\$facname"
}
gtkwave::addSignalsFromList \$all_facs
gtkwave::setZoomRangeTimes 0 [gtkwave::getMaxTime]
gtkwave::setWindowStartTime 0

# Save configuration
gtkwave::saveFile "${WAVES_DIR}/${tb_name}.sav"

# Write PPM image (which we'll convert to PNG)
set dumpfile [gtkwave::getDumpFileName]
gtkwave::write_ppm_file "${WAVES_DIR}/${tb_name}_waves.ppm"
gtkwave::quit
EOL

        # Run gtkwave to generate image
        gtkwave -S "${WAVES_DIR}/${tb_name}_capture.tcl" "${WAVES_DIR}/${tb_name}_tb.vcd"

        # Convert PPM to PNG if ImageMagick is available
        if command -v convert &> /dev/null; then
            convert "${WAVES_DIR}/${tb_name}_waves.ppm" "${WAVES_DIR}/${tb_name}_waves.png"
            rm "${WAVES_DIR}/${tb_name}_waves.ppm"
        fi

        echo "Generated waveform for $tb_name"
        echo "----------------------------------------"
    else
        echo "Failed to compile $tb_name"
        echo "----------------------------------------"
    fi
}

# Install required packages
echo "Installing required packages..."
sudo pacman -S --noconfirm imagemagick || {
    echo "Failed to install ImageMagick"
}

echo "Starting testbench processing..."

# Process individual modules first
for tb_path in "$TB_IMPORTS"/*_tb.v "$TB_NEW"/*_tb.v; do
    if [ -f "$tb_path" ]; then
        base_name=$(basename "$tb_path" _tb.v)
        src_file="$SRC_DIR/${base_name}.v"
        if [ -f "$src_file" ]; then
            run_testbench "$tb_path" "$src_file"
        fi
    fi
done

echo "All testbenches processed. Waveforms saved in $WAVES_DIR"
