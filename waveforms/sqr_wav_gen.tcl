set vcd_file [gtkwave::getBaseDirectory]/sqr_wav_gen_tb.vcd
gtkwave::/File/New
gtkwave::/File/Open_New_Tab $vcd_file

# Add all signals
set nfacs [ gtkwave::getNumFacs ]
set all_facs [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    lappend all_facs "$facname"
}
set num_added [ gtkwave::addSignalsFromList $all_facs ]

# Zoom full
gtkwave::/Time/Zoom/Zoom_Full

# Save image
gtkwave::/File/Export/Write_PNG_Image waveforms/sqr_wav_gen_waves.png

# Exit gtkwave
gtkwave::/File/Quit
