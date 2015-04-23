start NOOP ;starting the program
		LDR R1 #1
		LDR R4 #16 ;16 bits before looping -- get to here sofar
count	SUBV R4 R4 #1
		PRESENT R4 start ;if R4=0 go to start
		ADD R1 R1 R1 ;double the number
		LSIP R0
		OR R0 R0 R1 ;or it with LSIP
		SSOP R0
		LDR R3 #65535 ;max register size, 16 bits
moretime SUBV R3 R3 #1
		PRESENT R3 count ;if R3=0 go to time
		JMP moretime
ENDPROG