;22i-1630 Tehreem Zafar
;22i-7431 Umar Murtaza
;CY-A
;COAL Final Project

outp macro x	;macro to reduce repitition
	mov dl,x
	mov ah,02h
	int 21h
endm

.model small
.stack 100h

.data

	gameName db "CANDY CRUSH GAME$"
	mainMenu db "Welcome to Main Menu", 10,13,"$"
	player db "Enter Player's Name: $"
	playerName db 20 dup(0)
	fname db "players.txt"
	fhandle dw ?
	start db "Let's Get Started$"
	rules db "How To Play$"
	r1 db "* You can make combinations of three or more candies. The more the better.$"
	r2 db "* Same Color and Same Shape candies can be swapped.$"
	r3 db "* Board will be updated after crushing matched candies.$"

	random db 0
	count db 0
	x dw 0
	y dw 0

	board db 49 dup(0)
	yline db 0
	var dw 0
	var2 dw 0
	
	moves db 0
	level db "level:$"
	levelnum db 0
	scorestr db "score:$"
	score db 0
	movesstr db "moves:$"
	getx dw 0
	gety dw 0
	index1 db 0
	index2 db 0
	getx1 dw 0
	gety1 dw 0
	number db 0
	regbl db 0
	invalid db "Try Again$"
	candycount db 0
	candytype db 0
	pname_len db 0
	valid db 0
	combo db 0
	page_border db "@@@@@@@@@@**********@@@@@@@@@@**********$"
	newlinestr db 10, 13, '$'
	crushing db "Match Made"
	exploded db "Sweeeet", '$'
	colorbomb db 0
	matches db 0
	dotted db "       -----------------------", 10,13,"$"
	tag db       "       |       level: $"      
	success db  "      YAYY SUCCESS $"
	failure db  "      UHHUH FAILED $"

.code
main proc
	mov ax,@data
	mov ds,ax
	
	mov ah,3ch 		;file creation
	mov cl,0		;to enter read only mode
	
	mov dx, offset fname
	int 21h
	mov fhandle,ax
	
	mov ah,00h     
	mov al,0dh   
	int 10h
	
	mov ah,0bh
	mov bh,00h
	mov bl,02h 	;green bg
	int 10h

	mov ah,06h	;scroll-up window
	mov al,0
	mov bh,02h		;text and background colour
	mov ch,0		;upper row number	
	mov cl,0		;left col
	mov dh,24
	mov dl,79
	int 10h
	
	;display msg
	call border_page
	mov ah,02h
	mov bh,0
	mov dh,6		
	mov dl,3		
	int 10h
	
	mov dx, offset gameName	
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,16	 
	mov dl,7	
	int 10h
	
	mov dx, offset player		
	mov ah,09h
	int 21h
		
	
	mov si, offset playerName		
	.repeat
		inc pname_len
		mov ah,01
		int 21h
		mov ah,0
		mov [si],al
		inc si
	.until al== 13			
	mov byte ptr [si], 36	
	
	;writing name in .txt file
	mov ah,3dh 		
	mov cl,2		
	int 21h
	
	mov cx, lengthof playerName
	mov bx,fhandle	
	mov dx,offset playerName
	mov ah,40h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,21		
	mov dl,8		
	int 10h
	
	mov dx, offset start	
	mov ah,09h
	int 21h
	
	mov ah,08h
	int 21h
	
	call rulespage	
	
	mov ah,08h
	int 21h
	
	
	
	
	.repeat
		call mainmenu_page
		mov ah,08h
		int 21h
		sub al,48
		mov levelnum,al

		.if al == 1
			mov levelnum,1
			mov ah,05h		
			mov al,03h
		
			mov ah,0bh
			mov bh,02h
			mov bl,0h 	;background colour
			int 10h
	
			mov ah,06h	;scroll-up window
			mov al,0
			mov bh,00h		;text and background colour
			mov ch,0		;upper row number	
			mov cl,0		;left col
			mov dh,24
			mov dl,79
			int 10h
	
			call level1
		.elseif al == 2
			mov levelnum,2
			mov ah,05h		;move to next page with board display
			mov al,04h
		
			mov ah,0bh
			mov bh,02h
			mov bl,0h 	;background colour
			int 10h
	
			mov ah,06h	;scroll-up window
			mov al,0
			mov bh,00h		;text and background colour
			mov ch,0		;upper row number	
			mov cl,0		;left col
			mov dh,24
			mov dl,79
			int 10h
			
			call level2			
			
		.elseif al == 3
		
			mov levelnum,3
			mov ah,05h		;move to next page with board display
			mov al,05h
	
			mov ah,0bh
			mov bh,02h
			mov bl,0h 	;background colour
			int 10h
	
			mov ah,06h	;scroll-up window
			mov al,0
			mov bh,00h		;text and background colour
			mov ch,0		;upper row number	
			mov cl,0		;left col
			mov dh,24
			mov dl,79
			int 10h
	
			call  level3
		.endif
		call cls
		mov ah,00
		mov al,13
		int 10h
		mov ah,05h		;move to next page with board display
		mov al,06h
		
		mov ah,06h	;scroll-up window
		mov al,0
		mov bh,00h		;text and background colour
		mov ch,0		;upper row number	
		mov cl,0		;left col
		mov dh,24
		mov dl,79
		int 10h
			
		mov ah,02h
		mov bh,0
		mov dh,12
		mov dl,14
		int  10h
		.if score >150		
			lea dx,success		;screen displays level success
			mov ah,09h
			int 21h
		.else
			lea dx,failure		;screen displays level failed
			mov ah,09h
			int 21h
		.endif
		mov ah,08h 
		int 21h
		call cls
		mov ah,00
		mov al,13
		int 10h
	.until levelnum==0
	
;exits video mode
	mov ah,0		
	int 16h
	mov ah,03
	int 10h 
	
	mov ah,3eh		;closes file
	mov bx,fhandle
	int 21h

	mov ah,4ch
	int 21h
main endp


;rules page

rulespage proc
	mov ah,05h		;next pg
	mov al, 01h
	
	mov ah,0bh
	mov bh,00h
	mov bl,02h 	;background colour
	int 10h
	
	mov ah,06h	;scroll-up window
	mov al,0
	mov bh,02h		;text and background colour
	mov ch,0		;upper row number	
	mov cl,0		;left col
	mov dh,24
	mov dl,79
	int 10h
	
	mov ah,02h
	mov bh, 0
	mov dh,2		;displays message in line 2
	mov dl,0		;starts display with a gap of 0 spaces
	int 10h
	
	lea dx, page_border	;displays gamename
	mov ah,09h
	int 21h

	mov ah,02h
	mov bh,0
	mov dh,24		;displays message in line 24
	mov dl,0		;starts display with a gap of 0 spaces
	int 10h
	
	lea dx, page_border	;displays designed  stripe
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,5		;displays message in line 5
	mov dl,15		;starts display with a gap of 15 spaces
	int 10h
	
	mov dx, offset rules	;displays game rules
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,11	;displays message in line 11
	mov dl,2		;starts display with a gap of 2 spaces
	int 10h
	
	mov dx, offset r1	;displays rule1
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,15	;displays message in line 15
	mov dl,2		;starts display with a gap of 2 spaces
	int 10h
	
	mov dx, offset r2	;displays rule1
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,18		;displays message in line 18
	mov dl,2		;starts display with a gap of 2 spaces
	int 10h
	
	mov dx, offset r3	
	mov ah,09h
	int 21h
	ret
rulespage endp

;main menu page

mainmenu_page  proc uses  ax bx cx dx 
	
	mov ah,05h		;displays third page with menu
	mov al,02h
	
	mov ah,0bh
	mov bh,00h
	mov bl,02h 	;background colour
	int 10h

	mov ah,06h	;scroll-up window
	mov al,0
	mov bh,02h		;text and background colour
	mov ch,0		;upper row number	
	mov cl,0		;left col
	mov dh,24
	mov dl,79
	int 10h
	
	call border_page
	mov ah,02h
	mov bh,0
	mov dh,4		;displays message in line 4
	mov dl,2		;starts display with a gap of 2 spaces
	int 10h
	
	
	lea dx,mainMenu
	mov ah,09h
	int 21h
	
	call nl
	call nl

	lea dx,dotted
	mov ah,09h
	int 21h
	
	lea dx,tag
	mov ah,09h
	int 21h
	
	outp '1'
	
	mov cx,0
	.while cx<6
		outp ' '
		inc cx
	.endw
	outp '|'
	call nl
	
	lea dx,dotted
	mov ah,09h
	int 21h
	
	call nl
	call nl
	
	lea dx,dotted
	mov ah,09h
	int 21h
	
	lea dx,tag
	mov ah,09h
	int 21h
	
	outp '2'
	
	mov cx,0
	.while cx<6
		outp ' '
		inc cx
	.endw
	outp '|'
	call nl
	
	lea dx,dotted
	mov ah,09h
	int 21h
	
	call nl
	call nl
	
	lea dx,dotted
	mov ah,09h
	int 21h
	
	lea dx,tag
	mov ah,09h
	int 21h
	
	outp '3'
	
	mov cx,0
	.while cx<6
		outp ' '
		inc cx
	.endw
	outp '|'
	call nl
	
	lea dx,dotted
	mov ah,09h
	int 21h
	ret
mainmenu_page endp

nl proc uses ax dx
	mov dl,10
	mov ah,02h
	int 21h
	mov dl,13
	mov ah,02h
	int 21h
	ret	
nl endp

;generate random num
rand proc uses ax bx cx dx
	mov ah,0
	mov al, 0
	int 1ah
	mov random,dl
	ret
rand endp

;border
border_page proc uses ax bx cx dx
	mov ah,06h	;scroll-up window
	mov al,0
	mov bh,02h		;text and background colour
	mov ch,0		;upper row number	
	mov cl,0		;left col
	mov dh,24
	mov dl,79
	int 10h

	mov ah,02h
	mov bh, 0
	mov dh,2		;displays message in line 3
	mov dl,0		;starts display with a gap of 0 spaces
	int 10h
	
	lea dx, page_border	;displays gamename
	mov ah,09h
	int 21h

	mov ah,02h
	mov bh,0
	mov dh,24		;displays message in line 24
	mov dl,0		;starts display with a gap of 0 spaces
	int 10h
	
	lea dx, page_border	;displays designed  stripe
	mov ah,09h
	int 21h
	
	ret
border_page endp

;cell block
block_border proc uses ax bx cx dx
	mov ah,0ch
	mov al,04h
	mov bx,x
	add bx,30
	mov cx,x

	.while cx<=bx		;2 || lines (horizontal)
		mov dx,y
		int 10h
		add dx,20
		int 10h
		inc cx	
	.endw

	mov bx,y
	add bx,20
	mov dx,y

	.while dx<=bx		;2 vertical
		mov cx,x
		int 10h
		add cx,30
		int 10h
		inc dx	
	.endw
	ret
block_border endp

;board initialize
initialize_board proc uses si ax
	mov count,0
	mov si,offset board		;address of board
	mov ax,0
	.repeat
		call rand			;repeats random function
		mov al,count			
		xor random,al		;random generated number is randomized even more xor
		mov al,random
		mov ah,0
		mov bl,5			;taking mod of 5
		div bl
		mov byte ptr [si],ah
		inc si
		inc count
	.until count==49
	ret	
initialize_board endp

;square candy yellow
sqr proc uses ax bx cx dx
	mov ah,0ch		;function call for drawing pixels
	mov al,0eh		;yellow color
	mov bh,01
	mov bx,x
	add bx,20		;x-axis range
	mov cx,x
	add cx,10
	mov dx,y
	add dx,5
	mov yline,dl
	add yline,10		;y-axis range
	.while cx<bx
		mov dx,y
		add dx,5
		int 10h
		.while dl<yline		;nested loop
			inc dx
			int 10h
		.endw
		inc cx	
	.endw
	ret
sqr endp


;blue rectangle candy
rect proc uses ax bx cx dx
	mov ah,0ch		;function call for drawing pixel
	mov al,01h		;blue color
	mov bh,01h
	mov bx,x
	add bx,25		;x-axis range
	mov cx,x
	add cx,5
	mov dx,y
	add dx,7
	mov yline,dl
	add yline,7		;y-axis range
	.while cx<bx
		mov dx,y
		add dx,7
		int 10h
		.while dl<yline		;nested loop
		inc dx
		int 10h
		.endw
		inc cx	
	.endw
	ret
rect endp

;light pink heart candy

heart proc uses ax bx cx dx
	
	mov ah,0ch		;function call for drawing pixels
	mov al,0ch		;pink colour
	mov bh,01h
	mov bx,0	
	mov cx,0
	mov dx,0
	mov cx,x
	mov dx,y
	add cx,11
	add dx,6
	int 10h
	inc cx 
	int 10h
	add cx,4
	int 10h
	inc cx
	int 10h
	inc dx
	mov cx,x
	add cx,10
	mov bx,cx			;drawing top curves of the heart
	add bx,9				;hard coded
	.while  cx<bx
		mov var,bx
		sub var,cx
		.if var!=5
		int 10h
		.endif
		inc cx
	.endw
	mov cx,x
	add cx, 10
	mov bx,cx
	add bx,9				;drawing 2 lined rectangle
	.while cx<bx
	mov dx,y
	add dx,8
	int 10h
	inc dx
	int 10h
	inc cx
	.endw
	inc dx					;drawing a downward triangle line by line
	mov cx,x
	add cx,11
	mov bx,cx
	add bx,7
	.while  cx<bx
		int 10h
		inc cx
	.endw
	inc dx
	mov cx,x
	add cx,12
	mov bx,cx
	add bx,5
	.while  cx<bx
		int 10h
		inc cx
	.endw
	inc dx
	mov cx,x
	add cx,13
	mov bx,cx
	add bx,3
	.while  cx<bx
		int 10h
		inc cx
	.endw
	inc dx
	mov cx,x
	add cx,14
	int 10h
	ret
heart endp

;purple triangle candy
triangle proc uses ax bx cx dx
	mov ax,x
	mov var, ax
	add var,15
	mov bh,0
	mov bx,0
	mov dx,y
	add dx,5
	mov yline,dl
	add yline,9
	mov ax,var
	mov var2, ax
	mov ah,0ch		;drawing pixels
	mov al,05h		;purple
	
	.repeat 
		mov cx,var
		.while cx<=word ptr var2
			int 10h
			inc cx
		.endw
		dec word ptr var			;decrementing starting point
		inc word ptr var2			;incrementing ending point
		inc dx
	.until dl==yline
	ret
triangle endp

;light blue diamond candy
diamond proc
	mov ax, x
	mov var, ax
	add var,15
	mov bh,0
	mov bx,0
	mov dx,y
	add dx,5
	mov yline,dl
	add yline,5		;y-axis range
	mov ax, var
	mov var2, ax
	mov ah, 0ch		;function call for drawing pixels
	mov al, 0bh		;light blue
	
	.repeat 				;loop for up-right triangle
		mov cx, word ptr var
		.while cx<=word ptr var2
			int 10h
			inc cx
		.endw
		dec word ptr var
		inc word ptr var2
		inc dx
	.until dl==yline
	add yline, 6
	.repeat 				;loop for downwards triangle
		mov cx, word ptr var
		.while cx<=word ptr var2
			int 10h
			inc cx
		.endw
		inc word ptr var
		dec word ptr var2
		inc dx
	.until dl==yline
	ret
diamond endp

;colour bomb
bomb proc uses ax bx cx dx
	mov ah,0ch		;drawing pixels
	mov al,00h
	mov bh,01
	mov bx,x
	add bx,20		;x-axis range
	mov cx,x
	add cx,10
	mov dx,y
	add dx,5
	mov yline,dl
	add yline,10			;y-axis range
	.while cx<bx			;draws vertical lines
		mov ah,0ch
		inc al
		mov dx,y
		add dx,5
		int 10h
		.while dl<yline
		inc dx
		int 10h
		.endw
		inc cx	
	.endw
	ret
bomb endp

;blockage
blockage proc uses ax bx cx dx
	mov ah,0ch
	mov al,0fh
	mov bx,x
	add bx,25
	mov cx,x
	add cx,5
	mov dx,y
	.while cx<bx			;printing diagonal left to right
		int 10h
		inc cx
		inc dx		
	.endw
	mov bx,x
	add bx,5
	mov cx,x
	add cx,25
	mov dx,y
	.while cx>bx			;printing diagonal righ to left
		int 10h
		dec cx
		inc dx		
	.endw
	ret
blockage endp

;fborder for candy selected

highlight proc uses ax bx cx dx
	mov ah,0ch
	mov al,0fh
	mov bx,x
	add bx,25
	mov cx,x
	add cx,2				;different measurements
	.while cx<=bx
		mov dx,y
		add dx,2
		int 10h
		inc dx
		add dx,17
		int 10h
		inc cx	
	.endw
	mov bx,y
	add bx,17
	mov dx,y
	add dx,2
	.while dx<=bx
		mov cx,x
		add cx,2
		int 10h
		add cx,25
		int 10h
		inc dx	
	.endw
	ret
highlight endp

;display details(name, level, moves etc)
level_details proc uses ax bx cx dx
	mov ah,06h	
	mov al,0
	mov bh,00h		
	mov ch,0		
	mov cl,0		
	mov dh,24
	mov dl,79
	int 10h
	
	mov ah,02h
	mov bh,0
	mov dh,2	
	mov dl,2	
	int 10h
	
	mov dx, offset gamename	
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,4		
	mov dl,29		
	int 10h
	
	;display level
	mov dx, offset level	
	mov ah,09h
	int 21h
	
	;level num
	mov dl, levelnum	
	add dl,48
	mov ah,02h
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,6		
	mov dl,29		
	int 10h
	
	mov si,offset playerName
	mov cl,0
	.while cl<pname_len
		mov dl,byte ptr [si]
		mov ah,02h
		int 21h
		inc si
		inc cl
	.endw
	
	mov ah,02h
	mov bh,0
	mov dh,8		
	mov dl,29		
	int 10h
	
	;display 'moves'
	mov dx, offset movesstr	
	mov ah,09h
	int 21h
	
	;display num of moves
	mov dl,moves	
	mov number,dl
	call displaynum
	
	;the total moves are 20
	outp '/'
	outp '2'
	outp '0'		
	
	mov ah,02h
	mov bh,0
	mov dh,10		
	mov dl,29		
	int 10h
	
	mov dx, offset scorestr			
	mov ah,09h
	int 21h
	
	mov dl,score	
	mov number,dl
	call displaynum
	
	ret
level_details endp

;display the board
;based on array
displayboard proc uses si  ax
	mov count,0
	mov si,offset board
	mov x,10
	mov y,30
	.while count<49
	mov al, [si]
		.if al!=5
		call block_border
		.endif
		.if al==0
			call sqr
		.elseif al==1
			call rect
		.elseif al==2
			call heart
		.elseif al==3
			call triangle
		.elseif al==4
			call diamond
		
		.elseif al==6
			call bomb
		.endif
		inc si
		add x,30
		.if x>=220
			mov x,10
			add y,20
		.endif
		inc count
	.endw
	ret
displayboard endp


;level 2 board
level2_board proc uses si
	mov si,offset board
	mov byte ptr [si],5			;hardcoding blockage as per level 2
	add si,3
	mov byte ptr [si],5
	add si,3
	mov byte ptr [si],5

	inc si
	mov byte ptr [si],5
	add si,6
	mov byte ptr [si],5

	add si,8
	mov byte ptr [si],5

	add si,6
	mov byte ptr [si],5
	add si,8
	mov byte ptr [si],5
	add si,6
	mov byte ptr [si],5
	inc si
	mov byte ptr [si],5

	mov byte ptr [si],5
	add si,3
	mov byte ptr [si],5
	add si,3
	mov byte ptr [si],5
	ret
level2_board endp


;level 3 board
level3_board proc uses si
	mov si,offset board
	mov count,3
	add si,3
	.while count<=49 		;vertically putting blockage
		mov byte ptr [si],5
		add si,7
		add count,7
	.endw
	mov si,offset board
	mov count,21
	add si,21
	.while count<28
		mov byte ptr [si],5		;horizontally putting blockage
		inc si
		inc count
	.endw
	ret
level3_board endp

getcoordinates proc uses ax bx cx dx
	mov ax,1		
	int 33h
	mov cx, 20
	mov dx, 440
	mov ax, 7
	int 33h
	mov cx, 30
	mov dx, 170
	mov ax, 8
	int 33h
	.repeat
		mov ax,3		;gets cursor co-ordinates
		int 33h
		mov getx,cx  	
		mov gety,dx 	
		mov cx,0h		;adding delay
		mov dx,0ffffh
		mov ah,86h
		int 15h
	.until bl==1	;until button click detected
	mov dx,0
	mov ax,getx
	mov bx,2		
	div bx
	mov getx,ax
	ret
getcoordinates endp


;multidigit num display
displaynum proc uses ax bx cx dx
	mov ax,0
	mov al,number
    mov cx, 0
    .while ax>0
        mov dx, 0
        mov bx, 10	
        div bx
        push dx		;stack push
        inc cx
    .endw
    .while cx!=0
        pop dx			;pop
        add dx, 30h
        mov ah, 2h;
        int 21h
        dec cx
    .endw
    ret
displaynum endp

;array index for x and y
check_block proc uses ax bx cx dx		
	mov count,0				
	mov x,10
	mov cx,getx
	.while x<cx			
		inc count		
		add x,30
	.endw
	sub x,30
	mov y,20
	mov cx,gety			
	mov bx,0
	.while y<cx			
		inc bx
		add y,20
	.endw
	sub y,10
	call highlight		
	mov ax,7
	dec bx
	mul bx
	add count,al
	dec count
	
	ret
check_block endp

;update score
; square candy = 1
; rectangle candy = 2
; heart candy = 3
; triangle candy = 3
;diamond candy = 4
score_update proc uses ax bx
	mov ax,0
	mov al,candycount
	.if candytype==0		;one square has 1 point
		mov bl,1
		mul bl
	.elseif candytype==1		;a rectangle has 2 points
		mov bl,2
		mul bl
	.elseif candytype==2		;heart has 3 points
		mov bl,3
		mul bl
	.elseif candytype==3		;triangle has 3 points
		mov bl,3
		mul bl
	.elseif candytype==4		;diamond has 4 points
		mov bl,4
		mul bl
	.endif
	add score,al
	ret
score_update endp

;candy crush check
check_for_matches proc uses si di ax bx cx dx
	mov matches, 0
	mov combo,0
	mov si,offset board
	mov count,0
	mov al,byte ptr [si]
	mov candytype, al
	mov candycount,1
	.while count <49		;checking for horizontal matches
		inc si
		mov al,candytype
		.if [si]==al		;if candy matches
			inc candycount		;increment counter
		.else 
			mov cl,candycount
			.if candycount>=3 && candytype!=5  	;if 3 candies of same type have been found
				mov matches, 1
				call score_update		;score uppdate after crushing candy
				mov di,si
				.repeat
					dec di
					mov byte ptr [di],7
					dec candycount
					mov combo,1
				.until candycount==0
			.endif
			.if cl==5	&& candytype !=5 && levelnum !=3	;incase of 5 candies matching a color bomb is added to the board
				sub si,3
				mov byte ptr [si],6
				add si,3
			.endif
			mov candycount,1		;resetting count
			mov al,[si]
			mov candytype,al
		.endif
		inc count
	.endw
	mov candycount,1
	mov ax,0
	.while al<7
		mov si,offset board
		mov dx,0
		mov dl,al
		add si,dx
		mov bl,byte ptr [si]
		mov candytype,bl
		mov ah,0
		.while ah<7
			add si,7
			.if bl == byte ptr [si]		;if candy matches
				inc candycount			;increment counter
			.else
				mov cl,candycount
				.if candycount>=3 && candytype !=5			;if 3 candies of same type have been found
					mov matches, 1
					call score_update
					mov di,si
					.repeat
						sub di,7
						mov byte ptr [di],7
						mov dl,byte ptr [di]
						dec candycount
						mov combo,1
					.until candycount==0
				.endif
				.if cl==5 && candytype !=5 && levelnum !=3				;incase of 5 candies matching a color bomb is added to the board
					sub si,21
					mov byte ptr [si],6
					add si,21
				.endif
				mov candycount,1 		;resetting count
				mov bl,byte ptr [si]
				mov candytype,bl
			.endif
			inc ah
		.endw
		inc al
	.endw
	ret
check_for_matches endp

;move validity
validity proc uses ax bx cx dx si
	mov ax,0
	mov bx,0
	mov al,index1
	mov bl,index2
	mov si,offset board		;moving address of board
	add si,ax
	.if byte ptr [si]==5			;checking if either of the indices point to blockage 
		jmp invalid1
	.endif
	mov si,offset board
	add si,bx
	.if byte ptr [si]==5
		jmp invalid2
	.endif
	mov count,0
	inc ax
	.if ax==bx
		inc count
	.endif
	sub ax,2
	.if ax==bx
		inc count
	.endif
	mov al,index1
	add ax,7
	.if ax==bx
		inc count
	.endif
	mov al,index1
	sub ax,7
	.if ax==bx
		inc count
	.endif
	.if count==0			;if counter hasnt been incremented even once move is invalid
		invalid2:
		invalid1:

		mov ah,02h
		mov bh,0
		mov dh,15		;displays message in line 15
		mov dl,28		;starts display with a gap of 29 spaces
		int 10h
	
		mov dx, offset invalid	;displays 'invalid move'
		mov ah,09h
		int 21h
		mov valid,1
	.endif
	ret
validity endp

;swap
swap proc uses si di ax bx
						;swaps both indices using si and di 
	mov si,offset board
	mov bx,0
	mov bl,index1
	add si,bx
	mov al,byte ptr[si]
	mov di,offset board
	mov bl,index2
	add di,bx
	mov ah,byte ptr [di]
	mov [si],ah
	mov [di],al

	ret
swap endp

;check for color bomb 
check_for_colorbomb proc uses si di bx cx 
	mov colorbomb, 0
	mov si,offset board
	mov di,offset board
	mov bx,0
	mov bl,index1
	add si,bx
	mov bl,index2
	add di,bx
	.if byte ptr [si]==6		;checks if either of selected indces are color bombs or not
		mov cl,byte ptr[di]
		mov candytype,cl
		mov byte ptr [si],7
		mov valid,1
	.elseif byte ptr [di]==6		;checks if either of selected indces are color bombs or not
		mov cl,byte ptr[si]
		mov candytype,cl
		mov byte ptr [di],7
		mov valid,1
	.else
		jmp over			;in case of no color bomb
	.endif
	mov colorbomb, 1
	
	mov count,0
	mov candycount,0
	mov cl, candytype
	mov si,offset board
	.while count<49		;traversing through entire array
		.if byte ptr[si]==cl		;if candy is found
			mov byte ptr [si],7		;candy popped
			inc candycount			
		.endif
		inc count
		inc si
	.endw
	inc moves
	call score_update		;score is updated
	over:
	ret
check_for_colorbomb endp

;new candies
repopulate proc uses si
	mov count,0
	mov si,offset board
	.while count<49		;board is traversed
		.if byte ptr [si]==7 || byte ptr [si]==5		;in case of blockage 5 or empty space 7 new candies are brought
			mov ax,0
			call rand		;random number generated
			mov al,random
			xor al,count		;number is randomized even more
			mov bl,5
			div bl
			mov byte ptr [si],ah
		.endif
		inc si
		inc count
	.endw
		ret
repopulate endp

;drop candies
drop_candies proc uses si cx
	mov si,offset board
	mov count,0
	.while count <49			;entire array is traversed
		.if byte ptr [si]==7 && count>=7		;in case of empty space found
			mov cl, count
			mov index1,cl
			sub cl,7
			mov index2,cl
			.repeat				;it is brought up to the top most row
				call swap
				sub index1,7
				sub index2,7
			.until index1<7
		.endif
		inc si
		inc count
	.endw
	ret
drop_candies endp

;level 1
level1 proc uses ax bx cx dx
	mov moves,1
	mov score,0
	call initialize_board

	.repeat
		mov ah,00h
		mov al,13
		int 10h
		call repopulate
		mov ch,0
		.repeat
				call check_for_matches
				call drop_candies
				call repopulate
				inc ch
		.until combo==0 || ch==6
		call level_details
		call displayboard
		call getcoordinates
		call check_block
		mov cl,count
		mov index1,cl
		mov cx,5h		;adding delay
		mov dx,0ffffh
		mov ah,86h
		int 15h
	
		call getcoordinates
		call check_block
		mov cl,count
		mov index2,cl 
		
		call validity
		call check_for_colorbomb
		.if valid==1
			mov valid,0
			jmp over
		.endif
				
		call swap
		call check_for_matches
	
		inc moves
		over:
		call drop_candies
		mov cx,7h		;adding delay
		mov dx,0ffffh
		mov ah,86h
		int 15h
		.if colorbomb==1
			xor ax, ax
			mov ah, 2h
			mov bh, 0
			mov dh, 15
			 mov dl, 28
			 int 10h
			mov dx, offset exploded
			mov ah,09h
			int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
		.else
			.if matches==1
				xor ax, ax
				mov ah, 2h
				mov bh, 0
				mov dh, 15
				mov dl, 28
				int 10h
				mov dx, offset crushing
				mov ah, 9h
				int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
			.endif
		.endif
		.if moves!=15
			call cls
		.endif
		
	.until moves==15

	ret
	
level1 endp

;level 2
level2 proc uses ax bx cx dx
	mov moves,1
	mov score,0
	call initialize_board
	call level2_board
	.repeat
	mov ah,00h
	mov al,13
	int 10h
	mov ch,0
		.repeat
				call check_for_matches
				call drop_candies
				call repopulate
				call level2_board
				inc ch
		.until combo==0 || ch==6
	call level_details
	call displayboard
	call getcoordinates
	call check_block
	mov cl,count
	mov index1,cl
	mov cx,5h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	
	call getcoordinates
	call check_block
	mov cl,count
	mov index2,cl 
	mov cx,5h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	call validity
	call check_for_colorbomb
	.if valid==1
		mov valid,0
		jmp over
	.endif
	call swap
	call check_for_matches

	inc moves
	over:
	call drop_candies
	mov cx,2h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	.if colorbomb==1
			xor ax, ax
			mov ah, 2h
			mov bh, 0
			mov dh, 15
			 mov dl, 28
			 int 10h
			mov dx, offset exploded
			mov ah,09h
			int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
		.else
			.if matches==1
				xor ax, ax
				mov ah, 2h
				mov bh, 0
				mov dh, 15
				mov dl, 28
				int 10h
				mov dx, offset crushing
				mov ah, 9h
				int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
			.endif
		.endif
	.if moves!=15
	call cls
	.endif
	.until moves==15
	ret
level2 endp

;level 3 
level3 proc uses ax bx cx dx
	mov moves,1
	mov score,0
	call initialize_board
	call level3_board
	.repeat
	mov ah,00h
	mov al,13
	int 10h
	mov ch,0
		.repeat
				call check_for_matches
				call drop_candies
				call repopulate
				call level3_board
				inc ch
		.until combo==0 || ch==6
	call level_details
	call displayboard
	call getcoordinates
	call check_block
	mov cl,count
	mov index1,cl
	mov cx,5h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	
	call getcoordinates
	call check_block
	mov cl,count
	mov index2,cl 
	mov cx,5h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	call validity
	call check_for_colorbomb
	.if valid==1
		mov valid,0
		jmp over
	.endif
	call swap
	call check_for_matches

	inc moves
	over:
	call drop_candies
	mov cx,2h		;adding delay
	mov dx,0ffffh
	mov ah,86h
	int 15h
	.if colorbomb==1
			xor ax, ax
			mov ah, 2h
			mov bh, 0
			mov dh, 15
			 mov dl, 28
			 int 10h
			mov dx, offset exploded
			mov ah,09h
			int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
		.else
			.if matches==1
				xor ax, ax
				mov ah, 2h
				mov bh, 0
				mov dh, 15
				mov dl, 28
				int 10h
				mov dx, offset crushing
				mov ah, 9h
				int 21h
				mov cx,5h		;adding delay
				mov dx,0ffffh
				mov ah,86h
				int 15h
			.endif
		.endif
	.if moves!=15
	call cls
	.endif
	.until moves==15
	ret
level3 endp

cls proc
	mov al,03
	mov ah,0
	int 10h
	ret
cls endp

end main