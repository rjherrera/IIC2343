!Frespace = $3E8000
!code = !Frespace+$08

org $00A300 ;Vamos a esta posicion de memoria que ocurre cuando hay una NMI (not masked interruption)
			;en el SNES esto significa que ocurre durante el V-Blank
			;El V-Blank era un periodo en los televisores antiguos que se usaba para refrescar la pantalla
			;Este V-blank se hacia a una frecuencia de 60FPS, durante el V-blank es la unica oportunidad
			;de hacer cambios en la memoria de video en el SNES
JML !code ;Saltamos a code

org !Frespace ;El codigo sera insertado en la posicion de memoria dada por !Freespace

db "ST","AR"			;
dw Fin-Inicio-$01		;Rats tag que protegen tu data del LM
dw Fin-Inicio-$01^$FFFF		;

Inicio:
	JML code
	
incsrc Tarea7.asm
	
code:
	SEP #$30 ;Usamos A, X e Y de 8 bits
	PHX
	PHY
	PHA ;Push de los registros
	
	LDA !sourceIndex ;Si el Source Index es 0 entonces asumimos que no hay transferencia
	BEQ +
	DEC A
	DEC A
	STA !sourceIndex ;ya que el 0 es para evitar transferencias cuando no es necesario, entonces 
						;cuando sourceIndex es 2 quiero que apunte al primer elemento de la source
						;table entonces le resto 2 para que apunte al primer elemento.
	
	REP #$20 ;Pasamos a modo Reg A de 16 bits
	LDA #$1801              
	STA $4300 ;$4300 tendra modalidad de escritura #$01. Revisar Regs.txt en https://floating.muncher.se/bot/regs.txt
				;Para mas referencias.
				;$4301 apuntara al registro $2118 que es un registro que indica en que posicion de la memoria
				;de video se esta escribiendo
	SEP #$20 ;Pasamos a modo Reg A de 8 bits
	
	LDA #$80                
	STA $2115 ;Seteamos el controlador de la memoria de video Revisar Regs.txt en https://floating.muncher.se/bot/regs.txt
	
	PHB ;Push del banco de memoria actual
	PHK ;Push del banco de memoria del program counter
	PLB ;Hacemos que el banco de memoria actual sea igual al del program counter
		;Esto se hace para poder tener comandos con indexacion por el registro Y como LDA tabla,y
		;ya que las direcciones de las tablas son de 24 bits pero no existe una indexacion por y 
		;que sea de 24 bits, al hacer esto los primeros 8 bits que son del banco de memoria donde
		;pertenece la tabla se obvian y entonces queda una indexacion de 16 bits que si esta permitida
	JSR start ;Llamamos el codigo de tu tarea
	PLB ;Recuperamos el banco de memoria actual
	
	LDA #$00
	STA !sourceIndex ;Ponemos el sourceIndex en 0 para evitar hacer transferencias innecesarias.
	
+
	PLA ;Pull de los registros 
	PLY
	PLX
	REP #$20 ;Estos comandos venian en el codigo fuente del juego y debido a que estamos inyectando codigo
	LDX #$04 ;debemos ponerlos para evitar problemas.
	JML $00A304
	
Fin:
print "This Patch use: $", bytes," bytes."