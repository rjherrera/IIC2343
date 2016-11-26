incsrc Params.asm ;Este archivo contiene los parametros

start: ;Esto es un label

	;Registros A,X e Y Parten en modalidad 8 bits.
	;Puedes usar REP #$20 para que A sea de 16 bits y SEP #$20 para que A sea de 8 bits
	;Puedes usar REP #$10 para que X e Y sean de 16 bits y SEP #$10 para que sean de 8 bits
	;REP #$30 es igual a usar REP #$20 y REP #$10, SEP #$30 es igual a usar SEP #$20 y SEP #$10
	
	;Puedes empezar tu codigo aqui

REP #$20
LDA !destination; se carga !destination en A (16 bits)
STA $2116; se guarda en $2116

LDX !sourceIndex; se carga !sourceIndex en X (8 bits), para saber si es 0 o 2
LDA sourceTable, x; ahora indexo el sourceTable con X, y se carga ese valor en A (16 bits)
STA $4302; se guarda en $4302

LDA !size; se carga !size en A (16 bits)
STA $4305; se guarda en $4305

SEP #$20
LDA !sourceBank; se carga !sourceBank en A (8 bits)
STA $4304; se guarda en $4304

LDA #$01; se carga #$01 en A (8 bits) para indicar que se inicie la transferencia
STA $420B; se guarda en $420B


RTS ; Este comando es equivalente al RET del computador basico