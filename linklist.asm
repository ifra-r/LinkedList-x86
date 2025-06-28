[org 0x100]

    jmp start

null: equ 0x0
head: dw 0x0
tail: dw 0x0
sizeOfLL: db 0
list: times 300 db 0

start:
    call clrscr

    mov ax, 0x5
    push list                   ;0x2020
    call insertAtFirst

    inc ax
    mov bx, list
    add bx, 30
    push bx
    call insertAtFirst

    inc ax
    mov bx, list
    add bx, 60
    push bx
    call insertAtEnd   ;insertAtFirst              ;insertAtEnd

    ; call delAtFirst
    ; call delAtEnd

    mov ax, 0xA
    add bx, 90  ;120
    push bx
    push 1
    call insertAtPos

    ; push 0x0
    ; push 0x2
    ; call getNodeAtPos
    ; pop cx

    ; mov si, 2000
    ; push cx
    ; call PrintNode

    ; push 0x0
    ; call delAtPos

    call reverseList
    call sasta_print

    endprog:
        mov ax, 0x4c00
        int 0x21

insertAtFirst:
    push bp
    mov bp, sp

    sub sp, 2
    mov word [bp-2], bx             ;savung val of bx so i can use it later

    pusha
    mov bx, [bp+4]                   ; starting address of node 

    setRegs:
        mov word [bx+4]  , ax
        ; set bx
            mov ax, [bp-2]                 ;value pf bx
            mov word [bx+6]  , ax
        mov word [bx+8]  , cx
        mov word [bx+10] , dx
        mov word [bx+12] , si
        mov word [bx+14] , di
        mov word [bx+16] , bp
        mov word [bx+18] , sp        
        mov word [bx+20] , cs
        mov word [bx+22] , ds
        mov word [bx+24] , es
        mov word [bx+26] , ss
        ;set ip
            mov ax, [bp+2]          ;ip value
            mov word [bx+28] , ax         ;ip

    ; is it the first node?
    cmp word [head], null                ; treatinh 0x0 as null for now
    jne notFirst
    
    first:
            mov word [bx+0] , null      ; prev
            mov word [bx+2] , null      ; next
            ; update head and tail as this node
            mov word [head], bx
            mov word [tail], bx                      
            jmp exit1 
            
    notFirst:            
                mov word [bx+0]  , null       ; prev 
                mov si, [head]     
                mov word [bx+2]  , si         ; next

    ; ; head->prev = thisNode                           ; if yes, no need to make the old head->prev = thisnode
    ;set links of neighbouring nodes
        mov si, word [head]              ; si has the address at head ie the node array ka start (starting word is placeholder for prev pointer). this is the best i can expalin                        
        mov [si], bx                     ; change that prev to currentNode  i.e oldHead->prev = thisNode

    exit1: 
    mov word [head], bx                     ; update head:  ;[bp+4]       ; this is at first so this became head
    inc byte [sizeOfLL]           ;size inc

    popa
    mov sp, bp
    pop bp
    ret 2

insertAtEnd:
    push bp
    mov bp, sp

    sub sp, 2
    mov word [bp-2], bx

    pusha

    mov bx, [bp+4]                    ; starting address
    set_regs:
        mov word [bx+4]  , ax
        ; set bx
            mov ax, [bp-2]                    ;value pf bx
            mov word [bx+6]  , ax
        mov word [bx+8]  , cx
        mov word [bx+10] , dx
        mov word [bx+12] , si
        mov word [bx+14] , di
        mov word [bx+16] , bp
        mov word [bx+18] , sp        
        mov word [bx+20] , cs
        mov word [bx+22] , ds
        mov word [bx+24] , es
        mov word [bx+26] , ss
        ; set ip
            mov ax, [bp+2]          ;ip value
            mov word [bx+28] , ax         ;ip

    ; is it the first node?
    cmp word [head], null
    jne not_first

    first_node:
                mov word [bx+0] , null      ; prev
                mov word [bx+2] , null      ; next
                ; update head and tail as this node
                mov word [head], bx
                mov word [tail], bx
                jmp exit2

    not_first:
        mov word [bx+2], null           ; next
        mov si, [tail]
        mov [bx+0], si                  ; prev


    ;set links of neighbouring nodes i.e Oldtail->next = thisnode
    mov si, word [tail]
    mov word [si+2], bx                 ;tail->next = tisNode

    exit2:
    mov word [tail], bx                 ; update tail      ; [bp+4]       ; this is at first so this became head
    inc byte [sizeOfLL]                 ;size inc

    popa
    mov sp, bp
    pop bp
    ret 2
delAtFirst:
    pusha

    ; algo for help
        ; if only 1 node : 
            ; head = null
            ; tail = null
        ; else
        ;                                                                       head->next->prev = null
        ;     head = head->next             ;update head
        ;     head->prev = null

    cmp word [sizeOfLL], 0x0
    je exit3                   ;if no nodes exist to del, simply exit

    ; more than one node?
    mov si, [head]
    mov bx, [si+2]              ; bx = head->next
    cmp bx, null
    jne multipleNodes

        mov word [head], null    
        mov word [tail], null
        jmp size_update1

    multipleNodes:
        ;  head update              ---> tail = tail->prev
        mov word [head], bx         ; bx has head next rn. so, head = head->next
        
        ; updatedHead->prev = null
        mov word [bx+0], null

        ; ;head = head->next
        ; mov bx, [head]
        ; mov ax, [bx+2]                  ; next of head
        ; mov word [head], ax             ; head = head->next 

        ; ; newHead->prev = null
        ; mov bx, [head]
        ; mov word [head+0], null         ; head->prev = null;

    size_update1:
                    dec byte [sizeOfLL]                 ;size update
    
    exit3:
        popa
        ret 

delAtEnd:
    pusha

    ; algo for help:
        ; if only 1 node : 
            ; head = null
            ; tail = null
        ; else
        ;     tail = tail->prev             ;update head
        ;     tail->next = null

    ; does any node even exist? 
    cmp word [tail], null
    je exit4                             ;if tail null, no node exists to delete

    ; node does exist    

    ; is there a node other then tail or do we have only one node
    ; check if tail->prev exists
    mov si, [tail]
    mov bx, [si+0]              ; bx = tail->prev  
    cmp bx, null
    jne multiple_nodes

            ; only one node
            mov word [head], null
            mov word [tail], null
            jmp size_update2

    multiple_nodes:

        ;  tail update              ---> tail = tail->prev
        mov word [tail], bx         ; bx has tail prev rn. so, tail = tail->prev
        
        ; updatedTail->next = null
        mov word [bx+2], null

    size_update2:
                    dec byte [sizeOfLL]                 ;size update
    exit4:
    popa
    ret
size:
    ; returns size in ax
    xor ax, ax
    mov al, byte [sizeOfLL]
    ret

isEmpty:
    ; returns res in ax
    cmp word [sizeOfLL], 0
    je empty_list

                xor ax, ax
                ret

    empty_list:                
                mov ax, 0x1
                ret
sasta_print: 
    ; for testing purposes
    ; only ax val and arrows
    pusha

    xor si, si
    push 0xb800
    pop es

    ; for help:    
        ; use bx for traversal
        ;val of ax is at [node+4]       while node is the starting index of node? duh            
    
    call isEmpty            ;res in ax
    cmp ax, 1
    je exit5                ; no node exists, so exit maaro

    xor cx, cx
    mov cl, byte [sizeOfLL]
    mov bx, [head]
    here:
        push si
        push word [bx+4]            ;ax value of that node
        call print_hex
                                    ; add si, 8 ;-----------conscious choice--------------------    ; 4 pos of val of ax added
        call print_arrow            ; it will change si itself

        ; update bx. now gwt next node
        mov ax, [bx+2]              ; next of node in ax
        mov bx, ax

        loop here

        ; kachra
            ; cmp word [bx], null 
            ; je exit5
            ; jmp here

    exit5:
    call print_null
    popa
    ret

createNode:
    ; just a dummy dunc that creates a node at specific pos, sets its link to null, doesnt really add this node to list, just intialises its registers, thats all. its ahelping func for insertatpos
    push bp
    mov bp, sp

    sub sp, 2
    mov word [bp-2], bx             ;savung val of bx so i can use it later

    pusha
    mov bx, [bp+4]                   ; starting address of node 

    mov word [bx+0] , null      ; prev
    mov word [bx+2] , null      ; next
    mov word [bx+4]  , ax
    ; set bx
    mov ax, [bp-2]                 ;value pf bx
    mov word [bx+6]  , ax
    mov word [bx+8]  , cx
    mov word [bx+10] , dx
    mov word [bx+12] , si
    mov word [bx+14] , di
    mov word [bx+16] , bp
    mov word [bx+18] , sp        
    mov word [bx+20] , cs
    mov word [bx+22] , ds
    mov word [bx+24] , es
    mov word [bx+26] , ss
    ;set ip
    mov ax, [bp+2]          ;ip value
    mov word [bx+28] , ax         ;ip

    popa
    mov sp, bp
    pop bp
    ret 2
isValidPosToInsert:
    ; rec res and pos
    ; recieves address to place node at AND pos to insert node at       ;
    push bp
    mov bp, sp
    push di

    mov word [bp+6], 0x0

    mov di, [bp+4]
    inc di
    cmp di, [sizeOfLL]
    jg exitfalse                ; if size = 5 -> insert at 7? paeen 6 te hega nai 
                mov word [bp+6], 0x1
    exitfalse:
    pop di
    mov sp, bp
    pop bp
    ret 2
getPrev_n_NextNode:         ; helping func for insert at pos
    ;recieves prev res and next res and pos
    push bp
    mov bp, sp
    pusha

    mov si, word [bp+4]     ; pos
    dec si                  ; pos -1

    mov cl, byte [sizeOfLL]
                                cmp cl, 0
                                je exitwithNull

    xor cx, cx
    mov bx, [head]
    nextNode:
        mov dx, cx
        cmp dx, si                                         ; is euqal to pos -1 
        jne notPrev
                mov word [bp+8], bx                          ;prev res
        notPrev:
            cmp dx, word [bp+4]                              ; if equal to pos, it will be the next node of current node
            jne notNext
                mov word [bp+6], bx                         ;next res
                jmp exitwithNull
        notNext:
        ; update bx. now gwt next node  --> for traversal
        mov ax, [bx+2]              ; next of node in ax
        mov bx, ax

        inc cl
        cmp cl, byte [sizeOfLL] 
        jl nextNode

    exitwithNull:
    popa
    mov sp, bp
    pop bp
    ret 2               ; only cleanup pos
PrintNode:
    ; rec node loc
    ; prints its ax val

    push bp
    mov bp, sp
    push bx

    mov bx, [bp+4]      ; node

    push si
    push word [bx+4]    ; ax val pf that node
    call print_hex
    pop si

    pop bx
    mov sp, bp
    pop bp
    ret 2
insertAtPos:
    ; recieves address to place node at AND pos to insert node at       ;
    push bp
    mov bp, sp
    sub sp, 4
    pusha

    cmp word [bp+4], 0              ;cmp pos with 0
    jne notthefirstnodeinlist
    ;pehla node
                                    push word [bp+6]    ;address
                                    call insertAtFirst
                                    jmp exit6

    notthefirstnodeinlist:
    ; is pos even valid?
        push 0x0
        push word [bp+4]            ; pos 
        call isValidPosToInsert
        pop word [bp-2]             ; res here
        cmp word [bp-2], 0x0        ; if not valid, skip creating node and exit this routine
        je exit6
    ; yes its valid:
    push word [bp+6]            ; push address to place node at
    call createNode             ; only creates node and sets prev and next to null
    inc byte [sizeOfLL]         ; size inc

    mov bx, word [bp+6]         ; starting address of node

    ; thisNode->prev = prevnode, prevNode->next = thisNode
    ; thisNode->next = nextnode, nextNode->prev = thisNode
    otherNodesExist:
    ; get node that will be prev and next of this node
                ;use bp-2 for prev node             --> for prev node: get the pos-1 node
                ;use bp-4 for next node             --> for next node: get the pos node

    mov word [bp-2], null
    mov word [bp-4], null

    push word [bp-2]        ;prev 
    push word [bp-4]        ;next
    push word [bp+4]        ;pos
    call getPrev_n_NextNode
    pop word [bp-4]         ;next
    pop word [bp-2]         ;prev

    ; set neighboring links
    mov si, word [bp-2]     ;prev
    mov di, word [bp-4]     ;next

    mov word [bx+0], si       ;thisnode->prev = prev wala node
    mov word [bx+2], di       ;thisnode->next = next wala node

    cmp si, null
    je skip1
                        mov [si+2], bx          ;prev wala node->next = this node
    skip1:
    cmp di, null
    je exit6
                        mov [di+0], bx          ;next wala node->prev = this node
    exit6:
    popa
    mov sp, bp
    pop bp
    ret 4
getNodeAtPos:
    ;rec nodeRes and pos
    push bp
    mov bp, sp
    pusha

    mov si, [bp+4]     ;pos
    xor cx, cx
    mov bx, [head]
    getNextNode:
        cmp cx, si                                         ; is euqal to pos -1 
        jne not_pos_node
                            mov word [bp+6], bx                          ;prev res
                            jmp exitgetNode

        not_pos_node:
        ; update bx. now gwt next node  --> for traversal
        mov ax, [bx+2]              ; next of node in ax
        mov bx, ax

        inc cl
        cmp cl, byte [sizeOfLL] 
        jl getNextNode

    exitgetNode:
    popa
    mov sp, bp
    pop bp
    ret 2

delAtPos:
    ; rec pos to del node at
    push bp
    mov bp, sp
    pusha

    ; pos -> node to del at pos
    ; get pos-1 node (prev to node to be deleted) i.e prevNode
    ; get pos+1 node (next to node to be deleted) i.e nextNode
    mov dx, word [bp+4]             ;pos

    ; is pos valid?
                    ; push 0
                    ; push dx
                    ; call isValidPosToDel
                    ; pop si
                    ; cmp si, 1
                    ; je exit7

    dec dx
    push word null
    push dx
    call getNodeAtPos
    pop si                          ; prevNode

    add dx, 2                       ; +1 to undo prev dec AND +1 for pos+1
    push word null
    push dx
    call getNodeAtPos
    pop di                          ; nextNode

    ; set prevNode->next = nextNode
    ; and nextNode->prev = prevNode
    cmp si, null
    je isFirstNode
                        mov [si+2], di                  ; [si+2] is prevNode->next and di is NextNode. so, ==>   prevNode->next = nextNode
                        jmp skipPrevNode

    isFirstNode:
                        mov word [head], di             ;next node is now head

    skipPrevNode:
    cmp di, null
    je isLastNode
                        mov [di+0], si                  ; [di+0] is nextNode->prev and si is prevNode. so, ==>   nextNode->prev = prevNode
                        jmp skipNextNode

    isLastNode:
                        mov word [tail], si             ;prev node is now tail
    
    skipNextNode:
                        dec byte [sizeOfLL]

    exit7:
    popa
    mov sp, bp
    pop bp
    ret 2
reverseList:
    push bp
    mov bp, sp
    pusha

    ; strategy:
                ; swap next and prev of each node
                ; tehn swap head and tail
                ; also in a loop traverse backwards!!! instead pf next node you will get prev node. why? cause paeen khudi swap kie next and prev?

    ; swap next and prev of each node:
    xor cx, cx
    mov cl, byte [sizeOfLL]
    mov bx, [head]
    next_node:
        mov si, [bx+0]      ;prev
        mov di, [bx+2]      ;next
        mov [bx+0], di      ; next at prev
        mov [bx+2], si      ; prev at next

        ; BACKWARD TRAVERSAL CAUSE WE ARE REVERSING AND SWAPPING PREV AND NEXT
        mov ax, [bx+0]              ; next of node in ax
        mov bx, ax                  ; update bx. now gwt next node
        loop next_node

    ; swap head and tail
    mov bx, [head]
    mov ax, [tail]
    mov [head], ax
    mov [tail], bx

    popa 
    mov sp, bp
    pop bp
    ret
; isValidPosToDel:
    ;     ; rec res and pos
    ;     ; recieves address to place node at AND pos to insert node at       ;
    ;     push bp
    ;     mov bp, sp
    ;     push di

    ;     mov word [bp+6], 0x1

    ;     mov di, [bp+4]              ; pos
    ;     cmp di, [sizeOfLL]          ; pos < size ==> true else false
    ;     jl exit_true                ; if size = 5 ---> can del at index 0,1,2,3,4
    ;                 mov word [bp+6], 0x0
    ;     exit_true:
    ;     pop di
    ;     mov sp, bp
    ;     pop bp
    ;     ret 2
print_null:
    ; use si as 
    ; es and si ki value caller func bheje ga malai maar k
    push ax
    mov ah, 0x07

    mov al, 'n'
    mov word [es:si], ax
    add si, 2

    mov al, 'u'
    mov word [es:si], ax  
    add si, 2 

    mov al, 'l'
    mov word [es:si], ax  
    add si, 2 

    mov al, 'l'
    mov word [es:si], ax  
    add si, 2  

    pop ax
    ret
print_arrow:
    ; use si as indexer
    ; es and si ki value caller func bheje ga malai maar k
    push ax
    mov ah, 0x07

    mov al, ' '
    mov word [es:si], ax
    add si, 2

    mov al, '-'
    mov word [es:si], ax  
    add si, 2 

    mov al, '>'
    mov word [es:si], ax  
    add si, 2 

    mov al, ' '
    mov word [es:si], ax  
    add si, 2  

    pop ax
    ret
print_hex:
    ;recieves index to print at and val on stcak as a parameter
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    mov ax, [bp+4]  ;ax = num
    mov bx, 16
    xor cx, cx
    ;split digits
    accessNextDigit:
        xor dx, dx
        div bx
        ;add dx, 0x30       ;30 is ascii of 0 in hex
        push dx
        inc cx      ;inc count of digits
        cmp ax, 0
        jnz accessNextDigit
    ;print each dig
    mov ax, 0xb800
    mov es, ax
    mov di, [bp+6]              ;INDEX TO PRINT AT FROM STACK
    mov di, si   ;-----------------conscious choice--------------------
    nextloc:
        pop dx
        mov ah, 0x07        ;attribute bit
                                        ; ======>  DIDNT WORK       mov al, byte [acode+dl]
        mov al, dl
        cmp dl, 0x9
        jg add_char_ascii

        add al, 0x30
        jmp skip_char_ascii

        add_char_ascii:
        add al, 0x41           ;0x41 is ascii of A    ;0x41 - A (0to9)
        sub al, 0xA

        skip_char_ascii:
        mov [es:di], al
        add di, 2
        loop nextloc
    mov si, di   ;-----------------conscious choice--------------------

    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax

    mov sp, bp   
    pop bp
    ret 4
clrscr: 
    push ax
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, 0                     ;location indexer

    nextpos:
        mov word[es:di], 0x0720   ;black ;space  character
        add di, 2                 ;next cell
        cmp di, 4000              ;total cells - 80*25= 2000 (2 byte cells) so 4000
        jnz nextpos

    pop di
    pop es
    pop ax
    ret
; node struct for understanding:
    ; myNode: dw prev, next, ax_val, bx_val, .....
; in c++ :
        ; class node {
        ;         node* prev; 
        ;         node* next;
        ;   values of registers:
        ;       ax, bx, cx, dx, si, di, bp, sp, cs, ds, es, ss, ip       =====>  30 bytes so far
        ;     }