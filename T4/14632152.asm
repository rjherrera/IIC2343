org 100h
    
jmp main
 
ceros:
    mov si, 0           ;i = 0
    cmp si, size1        ;while i < size
        je endceros
    whilei:
        mov cx, 0       ;j = 0
        mov suma, 0     ;suma = 0
        whilej:
            cmp cx, size1        ;while j < size
                je endwhilei1
            mov ax, cx          ;k=j
            mul size            ;k=j*size
            add ax, si          ;k=j*size+i
            mov k, ax
            lea bx, graph       ;dir del grafo
            add bx, k           ;bx = dir+k 
            mov ax, [bx]        ;ax = grafo[bx]
            mov ah, 0           ;fix
            add ax, suma        ;ax += suma 
            mov suma, ax
            inc cx
            jmp whilej
        endwhilei1:     ;verifica si la suma fue cero
            mov ibusqueda, 0 ; parte el iterador sobre ordering en 0
            cmp suma, 0   ;si lo fue ahora salta para ver si ese indice ya se habia probado
                je nosta 
        endwhilei2:
            inc si
            jmp whilei
    nosta:
        mov ax, ibusqueda
        cmp ax, size1    ; si ya comparo todo y no hubo iguales, tonces nosta, y puede retornar ese i, que es el i a agregar al orden topologico, pq tiene cero entradas
            je endceros
        lea bx, ordering
        add bx, ibusqueda
        mov ax, [bx]
        mov ah, 0       ;fix
        mov dx, si
        inc dx
        cmp ax, dx      ; si ax (que es algun elemento de ordering) es igual a dx (nodo actual), quiere decir q ese nodo ya se agregó al orden topologico
            je endwhilei2 
        inc ibusqueda
        jmp nosta
    endceros:
        ret  


topo:
    mov iter_graph, 0   ;i = 0
    inicio:
        mov ax, len_order
        cmp ax, size1
            je end
        ; Llamo a la funcion ceros, que guarda en SI el indice de aquella columna con solo ceros
        call ceros
        mov iter_graph, si
        lea bx, ordering
        add bx, iter_order
        mov cx, iter_graph
        inc cx
        ; Escribo en ordering ese indice de columna
        mov [bx], cx
        ; Lo siguiente pasa cada elemento de la fila i a 0
        mov si, 0   ; j = 0
        while0:
            cmp si, size1
                je endwhile0
            mov ax, iter_graph  ;k=i
            mul size            ;k=i*size
            add ax, si          ;k=i*size+j
            mov k, ax
            lea bx, graph
            add bx, k
            mov [bx], 0
            inc si
            jmp while0
        ; Fin del paso a 0
        endwhile0:
        inc iter_order
        inc len_order
        jmp inicio
        
   
main:     
    sub dx, dx
    mov dl, size
    mov size1, dx   
    call topo
end:
    ret


; Variables iniciales
size db 8
graph db 0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0
ordering db 0,0,0,0,0,0,0,0
; Variables iteradoras
iter_graph dw 0
iter_order dw 0
len_order dw 0
ibusqueda dw 0 
k dw 0 
; Variables auxiliares   
suma dw 0
size1 dw 0
 
;size db 4
;graph db 0,0,1,1,0,0,0,0,0,1,0,0,0,0,1,0   ; 1432
;graph db 0,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0   ; 1234
;graph db 0,1,1,1,0,0,0,0,0,1,0,1,0,0,0,0   ; 1324
;ordering db 0,0,0,0