[org 0x7c00]

start:
    ; --- CONFIGURAÇÃO INICIAL ---
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; --- CARREGAR MAIS SETORES ---
    mov ah, 02h    
    mov al, 02h    ; Lemos +2 setores (1024 bytes extras)
    mov ch, 00h    
    mov dh, 00h    
    mov cl, 02h    ; Começa no setor 2
    mov bx, 0x7e00 ; Endereço logo após o bootloader
    int 13h        

    jc start       

    ; --- MODO DE VÍDEO ---
    mov ax, 0003h
    int 10h

atualizar_tela:
    mov ax, 0600h
    mov bh, 60h    ; Fundo marrom/laranja
    xor cx, cx
    mov dx, 184Fh
    int 10h
    
    mov ah, 02h
    xor dx, dx
    int 10h

    mov si, menu_topo
    call print_string
    call ler_data_hora

main_loop:
    mov ah, 00h
    int 16h 

    cmp al, '1'
    je abrir_arquivos
    cmp al, '2'
    je abrir_internet
    cmp al, '3'
    je abrir_notas
    cmp al, '4'
    je abrir_painel
    jmp main_loop

; --- APLICATIVOS ---

abrir_arquivos:
    call limpar_janela
    mov si, msg_arquivos
    call print_string
    jmp esperar_voltar

abrir_internet:
    call limpar_janela
    mov si, msg_art_internet
    call print_string
    jmp esperar_voltar

abrir_notas:
    call limpar_janela
    mov si, msg_notas
    call print_string
    
    .loop_digitacao:
        mov ah, 00h
        int 16h        ; Espera tecla
        
        cmp al, 27     ; ESC: sai
        je atualizar_tela
        
        cmp al, 08     ; BACKSPACE
        je .backspace

        cmp al, 13     ; ENTER
        jne .imprimir
        
        mov ah, 0eh
        mov al, 13
        int 10h
        mov al, 10
        jmp .imprimir

    .backspace:
        ; Move o cursor para trás, imprime espaço, move para trás de novo
        mov ah, 0eh
        mov al, 08
        int 10h
        mov al, ' '
        int 10h
        mov al, 08
        int 10h
        jmp .loop_digitacao
        
    .imprimir:
        mov ah, 0eh
        int 10h
        jmp .loop_digitacao

abrir_painel:
    call limpar_janela
    mov si, msg_painel
    call print_string
    jmp esperar_voltar

esperar_voltar:
    mov si, msg_voltar
    call print_string
    mov ah, 00h
    int 16h
    jmp atualizar_tela

; --- FUNÇÕES AUXILIARES ---

limpar_janela:
    mov ax, 0600h
    mov bh, 07h    ; Fundo preto para os apps
    xor cx, cx
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    xor dx, dx
    int 10h
    ret

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0eh
    int 10h
    jmp print_string
.done:
    ret

print_char:
    mov ah, 0eh
    int 10h
    ret

ler_data_hora:
    mov ah, 04h
    int 1ah
    mov al, dl
    call print_bcd
    mov al, '/'
    call print_char
    mov al, dh
    call print_bcd
    mov al, ' '
    call print_char
    mov ah, 02h
    int 1ah
    mov al, ch
    call print_bcd
    mov al, ':'
    call print_char
    mov al, cl
    call print_bcd
    ret

print_bcd:
    push ax
    shr al, 4
    add al, '0'
    call print_char
    pop ax
    and al, 0Fh
    add al, '0'
    call print_char
    ret

; --- ASSINATURA DE BOOT ---
times 510-($-$$) db 0
dw 0xAA55

; ==========================================================
; --- SEGUNDO SETOR (DADOS) ---
; ==========================================================

menu_topo db '======================================================================', 13, 10
          db '                          PLUTONIUM OS                                ', 13, 10
          db '======================================================================', 13, 10
          db '[1] Arquivos               ------------------------------------------ ', 13, 10
          db '[2] Internet              |     Bem vindo ao PlutoniumOS, vc pode    |', 13, 10
          db '[3] Bloco de Notas        |     escolher os icones com os numeros    |', 13, 10
          db '[4] Painel de Controle    |           e letras do seu teclado        |', 13, 10  
          db '                           ------------------------------------------ ', 13, 10 
          db ' =====================================================================', 13, 10  
          db ' ------------------------------        #####             94           ', 13, 10  
          db '| O PlutoniumOS e um SO feito  |       ##  ##                         ', 13, 10  
          db '| em Assembly como um DOS que  |       #####   ##  ##                 ', 13, 10
          db '|    tenta simular uma GUI     |       ##      ##  ##                 ', 13, 10
          db ' ------------------------------        ##       #####                 ', 13, 10
          db ' =====================================================================', 13, 10 
          db ' Mo paz - Hora: ', 0
          db ' =====================================================================', 13, 10 

msg_arquivos db 'EXPLORADOR DE ARQUIVOS: C:\> ', 13, 10, 'Nenhum arquivo encontrado.', 0

msg_art_internet db ' _________    ____              ______ ', 13, 10
                 db '|         \  |    |    __   __ |_    _| ______  ________', 13, 10
                 db '|    |\    \ |    |   |  | |  |  |  |  |  __  ||   __   |', 13, 10
                 db '|     ______||    |   |  | |  |  |  |  | |  | ||  |  |  |', 13, 10
                 db '|    |       |    |__ |  |_|  |  |  |  | |__| ||  |  |  |', 13, 10
                 db '|____|       |_______||_______|  |__|  |______||__|  |__|', 13, 10, 13, 10
                 db '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 13, 10, 13, 10
                 db 'Erro 404 Sem internet', 0

msg_notas    db '--- BLOCO DE NOTAS (ESC para sair) ---', 13, 10, 0
msg_painel   db 'PAINEL DE CONTROLE:', 13, 10, 'Configuracoes de sistema indisponiveis.', 0
msg_voltar   db 13, 10, 13, 10, 'Pressione qualquer tecla para voltar ao menu...', 0

times 1024 db 0