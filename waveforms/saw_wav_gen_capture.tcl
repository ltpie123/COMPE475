set nfacs [ gtkwave::getNumFacs ]
set all_facs [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    lappend all_facs "$facname"
}
gtkwave::addSignalsFromList $all_facs
gtkwave::setZoomRangeTimes 0 [gtkwave::getMaxTime]
gtkwave::setWindowStartTime 0

# Save configuration
gtkwave::saveFile "waveforms/saw_wav_gen.sav"

# Write PPM image (which we'll convert to PNG)
set dumpfile [gtkwave::getDumpFileName]
gtkwave::write_ppm_file "waveforms/saw_wav_gen_waves.ppm"
gtkwave::quit
