# fp_mac_project
The Fixed Point MAC should use 16-bit fixed point numbers for the calculation.
It should have two SRAMs (SRAM_A and SRAM_B) and it should allow user to store up to 8 Fixed Point values in both SRAMs using numerical keypad.
In the final state, it should fetch each pair of FP numbers stored in SRAM A and SRAM B and multiply them using FP methods. 
Multiplied result should then be accumulated using FP Adder. Result is dot product of SRAM_A and SRAM_B
It should display the current state in LCD display controlled by Arduino.
It should display the final result in hex in onboard  7-segment displays.
FP MAC operation should be pipelined for better throughput.
