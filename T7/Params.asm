!size = #$0800 ;Cantidad de bytes (en hexa) que se enviaran por DMA
!destination = #$1800 ;Posicion en la memoria de video donde llegaran los graficos
!sourceBank = #$3F ;Banco de memoria donde estan almacenados los recursos

!sourceIndex = $0DA1 ;Direccion de memoria RAM utilizada como indexador de la tabla de recursos, si es #$FF 
						;No se debe transferir

sourceTable: dw $8008,$8808 ;Tabla de recursos, indica la posicion en la memoria ram donde estan almacenados los graficos
