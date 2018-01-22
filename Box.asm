 org 100h
.model small
.stack 100h 
 
.data 

m dw 2
n dw 1
init_x dw 50
init_y dw 80

next_x dw 0 
next_y dw 0

x_lim dw 0 
y_lim dw 0
curX dw 0
curY dw 0
curB dw 0

lx dw ?
ly dw ?
lxx dw ?
lyy dw ?
z db 0 
p db 0

 point_xy  dw 50,80,110,140,170,200,230,260,290,320,350,380,410,440,470,500
           dw 80,110,140,170,200,230,260,290,320,350,380,410,440,470,500,530              


print macro x, y, attrib, sdat
LOCAL   s_dcl, skip_dcl, s_dcl_end
    pusha
    mov dx, cs
    mov es, dx
     mov ah, 0h

    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, attrib
    mov cx, offset s_dcl_end - offset s_dcl
    mov dl, x
    mov dh, y
    mov bp, offset s_dcl
    int 10h
    popa
    jmp skip_dcl
    s_dcl DB sdat
    s_dcl_end DB 0
    skip_dcl:    
endm

clear_screen macro
    pusha
    mov ax, 0600h
    mov bh, 0000_1111b
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 10h
    popa
endm

print_space macro num
    pusha
    mov ah, 9
    mov al, ' '
    mov bl, 0000_1111b
    mov cx, num
    int 10h
    popa
endm


.code 
main proc
    
mov ax,@data
mov ds,ax

   


 jmp start





start:
mov ax, 1003h ; disable blinking.  
mov bx, 0        
int 10h

; hide text cursor:
mov ch, 32
mov ah, 1
int 10h


; reset mouse and get its status:
mov ax, 0
int 33h
cmp ax, 0
jne ok
print 1,1,0010_1111b, " mouse not found :-( "
jmp stop

ok:
clear_screen
call Grid

;print 15,1,0010_1011b," BOX GAME "
;print 1,3,0010_1011b," P1:  "
;print 32,3,0010_1011b," P2:  "
;print 10,11,0010_1111b,"  "

; display mouse cursor:
mov ax, 1
int 33h

check_mouse_buttons:
mov ax, 3
int 33h
cmp bx, 3  ; both buttons
je  hide
cmp cx, curX
jne print_xy
cmp dx, curY
jne print_xy
cmp bx, curB
jne print_buttons


print_xy:
print 0,0,0000_1111b,"x="
mov ax, cx
call print_ax
print_space 4
print 0,1,0000_1111b,"y="
mov ax, dx
call print_ax
print_space 4
mov curX, cx
mov curY, dx
jmp check_mouse_buttons

print_buttons:
print 0,2,0000_1111b,"btn="
mov ax, bx
call print_ax
print_space 4
mov curB, bx
call line 
jmp check_mouse_buttons



hide:
mov ax, 2  ; hide mouse cursor.
int 33h

clear_screen

print 1,1,1010_0000b," hardware must be free!      free the mice! "

stop:
; show box-shaped blinking text cursor:
mov ah, 1
mov ch, 0
mov cl, 8
int 10h

print 4,7,0000_1010b," press any key.... "
mov ah, 0
int 16h 


 exit:
 mov ah,4ch
 int 21h
 

ret
 
 
 
 

 main  endp


Grid proc
 mov ah, 0h
mov al ,13h
int 10h
mov al,15
mov ah,0ch
row:

column:
mov bx,init_y
add bx,next_y
mov dx,bx
mov y_lim,dx
mov bx,4
add y_lim,bx
lp1:
mov bx,init_x
add bx,next_x 
mov cx,bx 
mov x_lim,cx
mov bx,4
add x_lim,bx
lp2: 

    int 10h
    inc cx
    cmp cx,x_lim
    jle lp2
    inc dx
    cmp dx,y_lim 
    jle lp1
    
 add next_x,30
 dec m
 cmp m,0
 jne column 
  
  
 mov bx,next_x
 sub next_x,bx
 mov m,2
 
 add next_y,30
 dec n
 cmp n,0
 jne row     
    
Grid endp  



    

print_ax proc
cmp ax, 0
jne print_ax_r
    push ax
    mov al, '0'
    mov ah, 0eh
    int 10h
    pop ax
    ret 
print_ax_r:
    pusha
    mov dx, 0
    cmp ax, 0
    je pn_done
    mov bx, 10
    div bx    
    call print_ax_r
    mov ax, dx
    add al, 30h
    mov ah, 0eh
    int 10h    
    jmp pn_done
pn_done:
    popa  
    ret  
endp

line proc 
    
cmp curB,1
je xxx
jmp dwn


xxx:
cmp z,0
jne yyy

mov ax,curX
mov lx,ax
mov ax,curY
mov ly,ax
inc z
mov curB,0
jmp dwn
yyy:
cmp z,1
mov ax,curX
mov lxx,ax
mov ax,curY
mov lyy,ax
mov curB,0
dec z
inc p 



cmp p,1
jne dwn 


mov cx,100

mov dx,80

print_line:
int 10h
inc cx
cmp cx,130
jle print_line
 
    
dwn:    
ret    
endp