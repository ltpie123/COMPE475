
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
create_project: 2

00:00:052

00:00:062	
486.3832	
182.414Z17-268h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental C:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/utils_1/imports/synth_1/top.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2i
gC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/utils_1/imports/synth_1/top.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
^
Command: %s
53*	vivadotcl2-
+synth_design -top top -part xc7a35tcpg236-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xc7a35tZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xc7a35tZ17-349h px� 
D
Loading part %s157*device2
xc7a35tcpg236-1Z21-403h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
2Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
N
#Helper process launched with PID %s4824*oasys2
16372Z8-7075h px� 
�
%s*synth2{
yStarting RTL Elaboration : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 1322.914 ; gain = 440.156
h px� 
�
synthesizing module '%s'%s4497*oasys2
top2
 2g
cC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/top.v2
228@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2

midi_input2
 2n
jC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_input.v2
458@Z8-6157h px� 
�
-case statement is not full and has no default155*oasys2n
jC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_input.v2
938@Z8-155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2

midi_input2
 2
02
12n
jC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_input.v2
458@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
synth2
 2i
eC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/synth.v2
648@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
midi_to_freq2
 2p
lC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_to_freq.v2
548@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
midi_to_freq2
 2
02
12p
lC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_to_freq.v2
548@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
wav_selector2
 2p
lC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/wav_selector.v2
608@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
sqr_wav_gen2
 2o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/sqr_wav_gen.v2
558@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
sqr_wav_gen2
 2
02
12o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/sqr_wav_gen.v2
558@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
sin_wav_gen2
 2o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/sin_wav_gen.v2
568@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
sin_wav_gen2
 2
02
12o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/sin_wav_gen.v2
568@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
saw_wav_gen2
 2o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/saw_wav_gen.v2
548@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
saw_wav_gen2
 2
02
12o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/saw_wav_gen.v2
548@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
tri_wav_gen2
 2o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/tri_wav_gen.v2
568@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
tri_wav_gen2
 2
02
12o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/tri_wav_gen.v2
568@Z8-6155h px� 
�
default block is never used226*oasys2p
lC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/wav_selector.v2
1098@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
wav_selector2
 2
02
12p
lC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/wav_selector.v2
608@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
adsr_envelope2
 2q
mC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/adsr_envelope.v2
498@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
adsr_envelope2
 2
02
12q
mC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/adsr_envelope.v2
498@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
synth2
 2
02
12i
eC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/synth.v2
648@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
	pwm_audio2
 2m
iC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/pwm_audio.v2
658@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	pwm_audio2
 2
02
12m
iC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/pwm_audio.v2
658@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
top2
 2
02
12g
cC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/top.v2
228@Z8-6155h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2
data_byte1_reg2n
jC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/midi_input.v2
858@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2
direction_reg2o
kC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/tri_wav_gen.v2
758@Z8-6014h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
mult_temp_reg2
adsr_envelope2q
mC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/imports/new/adsr_envelope.v2
1428@Z8-7137h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[15]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[14]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[13]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[12]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[11]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[10]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[9]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[8]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[7]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[6]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[5]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[4]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[3]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[2]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[1]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[0]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[15]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[14]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[13]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[12]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[11]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[10]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[9]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[8]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[7]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[6]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[5]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[4]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[3]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[2]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[1]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[0]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[15]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[14]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[13]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[12]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[11]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[10]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[9]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[8]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[7]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[6]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[5]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[4]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[3]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[2]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[1]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[0]2
adsr_envelopeZ8-7129h px� 
r
9Port %s in module %s is either unconnected or has no load4866*oasys2

note_valid2
synthZ8-7129h px� 
�
%s*synth2{
yFinished RTL Elaboration : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1435.504 ; gain = 552.746
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1435.504 ; gain = 552.746
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1435.504 ; gain = 552.746
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0122

1435.5042
0.000Z17-268h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
Parsing XDC File [%s]
179*designutils2x
tC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/constrs_1/imports/new/basys3_constraints.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2x
tC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/constrs_1/imports/new/basys3_constraints.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2v
tC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/constrs_1/imports/new/basys3_constraints.xdc2
.Xil/top_propImpl.xdcZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1488.8832
0.000Z17-268h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
 Constraint Validation Runtime : 2

00:00:002
00:00:00.0152

1488.8832
0.000Z17-268h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Loading part: xc7a35tcpg236-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
n
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2

midi_inputZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                    IDLE |                              000 |                              000
h p
x
� 
y
%s
*synth2a
_               START_BIT |                              001 |                              001
h p
x
� 
y
%s
*synth2a
_               DATA_BITS |                              010 |                              010
h p
x
� 
y
%s
*synth2a
_                STOP_BIT |                              011 |                              011
h p
x
� 
y
%s
*synth2a
_            PROCESS_BYTE |                              100 |                              100
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2

sequential2

midi_inputZ8-3354h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:15 ; elapsed = 00:00:16 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   16 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit       Adders := 1     
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               32 Bit    Registers := 3     
h p
x
� 
H
%s
*synth20
.	               16 Bit    Registers := 2     
h p
x
� 
H
%s
*synth20
.	                8 Bit    Registers := 10    
h p
x
� 
H
%s
*synth20
.	                7 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                3 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                2 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 3     
h p
x
� 
-
%s
*synth2
+---Multipliers : 
h p
x
� 
F
%s
*synth2.
,	              32x33  Multipliers := 3     
h p
x
� 
&
%s
*synth2
+---ROMs : 
h p
x
� 
>
%s
*synth2&
$	                    ROMs := 1     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   27 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   16 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   3 Input   16 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input   16 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input    8 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit        Muxes := 6     
h p
x
� 
F
%s
*synth2.
,	   4 Input    8 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input    4 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    3 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   8 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   3 Input    2 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 16    
h p
x
� 
F
%s
*synth2.
,	   5 Input    1 Bit        Muxes := 7     
h p
x
� 
F
%s
*synth2.
,	   6 Input    1 Bit        Muxes := 1     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
%s
*synth2X
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[15]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[14]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[13]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[12]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[11]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[10]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[9]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[8]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[7]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[6]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[5]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[4]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[3]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[2]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[1]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
attack_time[0]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[15]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[14]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[13]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[12]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[11]2
adsr_envelopeZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[10]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[9]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[8]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[7]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[6]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[5]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[4]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[3]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[2]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[1]2
adsr_envelopeZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
decay_time[0]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[15]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[14]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[13]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[12]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[11]2
adsr_envelopeZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[10]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[9]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[8]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[7]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[6]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[5]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[4]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[3]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[2]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[1]2
adsr_envelopeZ8-7129h px� 

9Port %s in module %s is either unconnected or has no load4866*oasys2
release_time[0]2
adsr_envelopeZ8-7129h px� 
r
9Port %s in module %s is either unconnected or has no load4866*oasys2

note_valid2
synthZ8-7129h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:22 ; elapsed = 00:00:23 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
h px� 
l
%s*synth2T
R---------------------------------------------------------------------------------
h px� 
;
%s*synth2#
!
ROM: Preliminary Mapping Report
h px� 
Y
%s*synth2A
?+-------------+-------------+---------------+----------------+
h px� 
Z
%s*synth2B
@|Module Name  | RTL Object  | Depth x Width | Implemented As | 
h px� 
Y
%s*synth2A
?+-------------+-------------+---------------+----------------+
h px� 
Z
%s*synth2B
@|midi_to_freq | freq_out    | 128x11        | LUT            | 
h px� 
Z
%s*synth2B
@|sin_wav_gen  | wav_out_reg | 256x8         | Block RAM      | 
h px� 
Z
%s*synth2B
@+-------------+-------------+---------------+----------------+

h px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
h px� 
l
%s*synth2T
R---------------------------------------------------------------------------------
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:26 ; elapsed = 00:00:28 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2
}Finished Timing Optimization : Time (s): cpu = 00:00:29 ; elapsed = 00:00:32 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys22
0synth_inst/wav_sel_inst/sin_wav_inst/wav_out_reg2
BlockZ8-7052h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2~
|Finished Technology Mapping : Time (s): cpu = 00:00:30 ; elapsed = 00:00:33 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2x
vFinished IO Insertion : Time (s): cpu = 00:00:35 ; elapsed = 00:00:37 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:35 ; elapsed = 00:00:37 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
4
%s*synth2
+------+---------+------+
h px� 
4
%s*synth2
|      |Cell     |Count |
h px� 
4
%s*synth2
+------+---------+------+
h px� 
4
%s*synth2
|1     |BUFG     |     1|
h px� 
4
%s*synth2
|2     |CARRY4   |   666|
h px� 
4
%s*synth2
|3     |LUT1     |    92|
h px� 
4
%s*synth2
|4     |LUT2     |   978|
h px� 
4
%s*synth2
|5     |LUT3     |   620|
h px� 
4
%s*synth2
|6     |LUT4     |   959|
h px� 
4
%s*synth2
|7     |LUT5     |   510|
h px� 
4
%s*synth2
|8     |LUT6     |   495|
h px� 
4
%s*synth2
|9     |MUXF7    |     2|
h px� 
4
%s*synth2
|10    |RAMB18E1 |     1|
h px� 
4
%s*synth2
|11    |FDCE     |   148|
h px� 
4
%s*synth2
|12    |FDRE     |   200|
h px� 
4
%s*synth2
|13    |IBUF     |     9|
h px� 
4
%s*synth2
|14    |OBUF     |     1|
h px� 
4
%s*synth2
+------+---------+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
a
%s
*synth2I
GSynthesis finished with 0 errors, 0 critical warnings and 50 warnings.
h p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:00:26 ; elapsed = 00:00:36 . Memory (MB): peak = 1488.883 ; gain = 552.746
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 1488.883 ; gain = 606.125
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0952

1499.1842
0.000Z17-268h px� 
U
-Analyzing %s Unisim elements for replacement
17*netlist2
669Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1502.9102
0.000Z17-268h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

6bb06964Z4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
482
1022
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
synth_design: 2

00:00:402

00:00:442

1502.9102

1009.355Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0192

1502.9102
0.000Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2Y
WC:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.runs/synth_1/top.dcpZ17-1381h px� 
z
%s4*runtcl2^
\Executing : report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb
h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Thu Dec  5 17:51:52 2024Z17-206h px� 


End Record