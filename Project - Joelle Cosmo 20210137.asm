org 100h
.data
    square db 219   
    color db 0  
    count_white db 0    
    count_blue db 0    ; Count of squares in blue
    count_green db 0   ; Count of squares in green
    count_red db 0     ; Count of squares in red
    count_purple db 0 ; Count of squares in purple
    count_brown db 0   ; Count of squares in brown
    count_yellow db 0   ; Count of squares in yellow
    count_cyan db 0    ; Count of squares in white
    count db 0     
    red_report db 'Red squares:$'
    blue_report db 'Blue squares:$'
    green_report db 'Green squares:$'
    yellow_report db 'Yellow squares:$'
    purple_report db 'Purple squares:$'
    brown_report db 'Brown squares:$'
    cyan_report db 'Cyan squares:$'
    white_report db 'White squares:$'
    backspace db 8   
    flag db 0 
    color_flag_up db 0
    color_flag_down db 0  
    flag_enter_once db 0
    flag_ db 0
    first_square_flag db 1 
    colors db 1, 2, 3, 4, 5, 6, 14
    color_index dw 0 
                   .code 
mov ax, @data
    mov ds, ax
              
    new_square:
    cmp first_square_flag, 1  
    je first
    cmp bl, 1
    je inc_blue
    back1:
    cmp bl, 2
    je inc_green
    back2:
    cmp bl, 3
    je inc_cyan
    back3:
    cmp bl,4
    je inc_red
    back4:
    cmp bl,5 
    je inc_purple 
    back5:
    cmp bl,6
    je inc_brown
    back6:
    cmp bl, 14
    je inc_yellow
    back7:
    
   first:
   dec first_square_flag
 
   mov cx,color_index
   mov cx, 0
   mov color_index, cx
   mov cl, flag
   mov cl, 0
   mov flag, 0
   mov cl, color_flag_up
   mov cl, 0
   mov color_flag_up, 0
   mov cl, color_flag_down
   mov cl, 0
   mov color_flag_down, 0
   mov ah, 2   
   mov dl, square
   int 21h                                          
   mov dl, ' '
   inc count          
   int 21h 
    
   
   
 l_:  mov ah, 0
    int 16h 
    
   
    cmp al, 13
    je new_square 
    
    cmp ah, 50h    
   
   je change_colordown 
    
   cmp ah, 48h 
   
   je change_colorup 
   ;jne testingthisout     
   ;jmp done
   
                        
;   ;jmp done
   cmp ah, 39h 
  
   je color_report
   

   change_colordown :
  
mov cl, color_flag_up
mov cl, 0              ;this handles the case where we press up after pressing down and changes it back to red but it doesn't go back to the colors above red
mov color_flag_up,cl     
j_:cmp flag,1
je x
mov ah,2 
mov dl, backspace
int 21h                   
mov dl, backspace
int 21h
inc flag
x: dec color_index
cmp color_index,0
jl set_color_index_to_max
jmp change_color_common
set_color_index_to_max:

mov color_index, 6
jmp change_color_common

change_colorup:
cmp flag,1
je x2
mov ah,2 
mov dl, backspace
int 21h
mov dl, backspace
int 21h 
inc flag
x2:
inc color_index
cmp color_index, 6
jg set_color_index_to_min
jmp change_color_common

set_color_index_to_min:
    mov color_index, 0
    
change_color_common:
    go:mov si, color_index     
mov bl, byte ptr [colors + si] 
    mov ah, 09h
    mov al, square
    mov bh, 0
    mov cx, 1
    int 10h
    ;cmp bl, 1

    jmp l_ 


inc_blue:
inc count_blue
jmp back1

inc_green:
inc count_green
jmp back2

inc_cyan:
inc count_cyan
jmp back3

inc_red:
inc count_red
jmp back4

inc_purple:
inc count_purple
jmp back5

inc_brown:
inc count_brown
jmp back6

inc_yellow:
inc count_yellow
jmp back7

inc_white:
inc count_white
jmp first

print_red_count: 
mov al, count_red
       
shr al, 1               
;inc al       add this to the greater than 9 label
mov count_red,al
mov dl, al       
cmp dl, 9
jbe lessthanorequalsnine_red
ja morethannine_red 
            
;----
print_blue_count:
;mov dl, count_blue 
mov al, count_blue       
shr al, 1               
;inc al
mov count_blue,al
mov dl, al        
cmp dl, 9
;cmp count_blue, 9    this is pending
jbe lessthanorequalsnine_blue
ja morethannine_blue
;----
print_yellow_count:
mov al, count_yellow       
shr al, 1               
;inc al
mov count_yellow,al
mov dl, al        
cmp dl, 9
;cmp count_yellow, 9          this is pending
jbe lessthanorequalsnine_yellow
ja morethannine_yellow   
;----  
print_cyan_count:
mov al, count_cyan      
shr al, 1               
;inc al
mov count_cyan,al
mov dl, al        
cmp dl, 9
;cmp count_cyan, 9  this is pending
jbe lessthanorequalsnine_cyan
ja morethannine_cyan
;----
print_green_count: 

mov al, count_green
      
shr al, 1               
;inc al
mov count_green,al
mov dl, al        
cmp dl, 9
;cmp count_green, 9    pending
jbe lessthanorequalsnine_green
ja morethannine_green 
;----
print_purple_count:
mov al, count_purple      
shr al, 1               
;inc al
mov count_purple,al
mov dl, al        
cmp dl, 9
;cmp count_purple, 9        pending
jbe lessthanorequalsnine_purple
ja morethannine_purple
;----
print_brown_count:
mov al, count_brown       
shr al, 1               
;inc al
mov count_brown,al
mov dl, al        
cmp dl, 9
;cmp count_brown, 9  pending
jbe lessthanorequalsnine_brown
ja morethannine_brown
;----

color_report:

mov si, 0  
;mov cl, 6
;mov ch,0
mov ah, 2

    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h  
l1:
    mov dl, red_report[si]
    cmp dl, '$'   
    je print_red_count  
    int 21h       
    inc si
    jmp l1
    new_line1:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h
mov si, 0
l2:
mov dl, blue_report[si]
    cmp dl, '$'   
    je print_blue_count  
    int 21h       
    inc si
    jmp l2 
new_line2:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h
mov si, 0
l3:
mov dl, yellow_report[si]
    cmp dl, '$'   
    je print_yellow_count  
    int 21h       
    inc si
    jmp l3
new_line3:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h 
mov si, 0
l4:
mov dl, cyan_report[si]
    cmp dl, '$'   
    je print_cyan_count 
    int 21h       
    inc si
    jmp l4
new_line4:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h 
mov si, 0 
l5:
mov dl, green_report[si]
    cmp dl, '$'   
    je print_green_count  
    int 21h       
    inc si
    jmp l5
new_line5:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h
mov si, 0
l6:
mov dl, purple_report[si]
    cmp dl, '$'   
    je print_purple_count  
    int 21h       
    inc si
    jmp l6
    
 new_line6:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h
mov si, 0  

l7:
mov dl, brown_report[si]
    cmp dl, '$'   
    je print_brown_count  
    int 21h       
    inc si
    jmp l7 
    
   new_line7:
    mov dl, 0ah  
    int 21h
    mov dl, 0dh  
    int 21h 
ret


done:
;mov ah, 2
;mov dl, 0ah
;int 21h
;mov dl, 0dh
;int 21h
;mov dl, 'c'
;int 21h
;mov dl, '='
;int 21h
;mov dl, count 
;cmp count, 9
;jbe lessthanorequalsnine
;ja morethannine
ret
;
;inc_blue:
;call inc_blue_
;
;inc_green:
;call inc_green_
;
;inc_yellow:
;call inc_yellow_
;
;inc_purple:
;call inc_purple_
;
;inc_cyan:
;call inc_cyan_
;
;
;inc_red:
;call inc_red_
;
;inc_brown:
;
;call inc_brown_


lessthanorequalsnine_red:
cmp count_red,0  
je h
inc dl 
h:add dl, 30h
int 21h 
jmp new_line1
morethannine_red:
inc count_red
mov bl, count_red
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah

mov ah, 2
int 21h


add bh, 30h
mov dl, bh
mov ah,2

int 21h

add bh, 30h
jmp new_line1
lessthanorequalsnine_blue:
cmp count_blue,0
je h1
inc dl
h1:add dl, 30h
int 21h 
jmp new_line2
morethannine_blue:
inc count_blue ;dont forget to remove it from above
mov bl, count_blue
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2

int 21h

add bh, 30h
jmp new_line2 
 
lessthanorequalsnine_yellow:
cmp count_yellow,0  
je h2
inc dl
h2:add dl, 30h
int 21h 
jmp new_line3
morethannine_yellow:
inc count_yellow ;dont forget to remove it from above
mov bl, count_yellow
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2
int 21h
add bh, 30h
jmp new_line3  

lessthanorequalsnine_cyan:
cmp count_cyan,0  
je h3
inc dl
h3:add dl, 30h
int 21h 
jmp new_line4
morethannine_cyan: 
inc count_cyan ;dont forget to remove it from above
mov bl, count_cyan
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2
int 21h
add bh, 30h
jmp new_line4


lessthanorequalsnine_green:
cmp count_green,0  
je h4
inc dl
h4:add dl, 30h
int 21h 
jmp new_line5 
morethannine_green:
inc count_green ;dont forget to remove it from above
mov bl, count_green
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2
int 21h
add bh, 30h
jmp new_line5

lessthanorequalsnine_purple:
cmp count_purple,0  
je h5
inc dl
h5:add dl, 30h
int 21h 
jmp new_line6 
morethannine_purple:
inc count_purple ;dont forget to remove it from above
mov bl, count_purple
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2
int 21h
add bh, 30h
jmp new_line6

lessthanorequalsnine_brown: 

cmp count_brown,0  
je h6
inc dl
h6:add dl, 30h
int 21h 
jmp new_line7 
morethannine_brown:
inc count_brown
mov bl, count_brown
mov ah, 0
mov al, bl
mov cl,10
div cl
add al, 30h
mov dl, al
mov bh, ah
mov ah, 2
int 21h
add bh, 30h
mov dl, bh
mov ah,2
int 21h
add bh, 30h
jmp new_line7   



done2:
;testingthisout:
;; Function to set text color (0 = black background, 7 = white text)
;mov ah, 9
;mov bh, 0    ; Page number
;mov bl, 4    ; Text attribute (white text on black background)
;mov cx, 1   ; Number of characters to display
;mov dx, offset square  ; Offset of the message
;int 10h
;jmp done
ret