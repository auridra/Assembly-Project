 org 100h
.model small
.stack 100h 
 
.data 

m dw 4
n dw 4
init_x dw 50
init_y dw 80

next_x dw 0 
next_y dw 0

x_lim dw 0 
y_lim dw 0

              



.code 
main proc
    
mov ax,@data
mov ds,ax


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
 mov m,4
 
 add next_y,30
 dec n
 cmp n,0
 jne row  
 exit:
 mov ah,4ch
 int 21h

endp main
end