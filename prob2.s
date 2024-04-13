.data

##### R1 START MODIFIQUE AQUI START #####

#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor1: .word 1 2 3 4 # Primeiro vetor
vetor2: .word 1 1 1 1 # Segundo vetor
vetor3: .word -5 -1 -2 -4   # Vetor com valores negativos
vetor4: .word -1 -1 -1 -1   # Vetor uniforme com valores negativos
vetor5: .word 1000 0 0 0    # Vetor com um valor alto e zeros
vetor6: .word 0 0 0 0       # Vetor com todos elementos zero

##### R1 END MODIFIQUE AQUI END #####
      
.text    

        add s0, zero, zero
        la a0, vetor1
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 2
        bne a0,t0,teste2
        addi s0,s0,1
teste2: la a0, vetor2
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 1
        bne a0,t0, teste3
        addi s0,s0,1
        #beq zero,zero, FIM

##### R2 START MODIFIQUE AQUI START #####

# Testes próprios

# Testes 3 e 4: Valores negativos
teste3:
        la a0, vetor3
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, -3    # Espera média de -3 para vetor3
        bne a0, t0, teste4
        addi s0, s0, 1
teste4:
        la a0, vetor4
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, -1    # Espera média de -1 para vetor4
        bne a0, t0, teste5
        addi s0, s0, 1

# Testes 5 e 6: Elementos zero e valores altos
teste5:
        la a0, vetor5
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 250   # Espera média de 250 para vetor5
        bne a0, t0, teste6
        addi s0, s0, 1
teste6:
        la a0, vetor6
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 0     # Espera média de 0 para vetor6
        bne a0, t0, FIM
        addi s0, s0, 1

# Esse espaço é para você escrever o código dos procedimentos. 
# Por enquanto eles estão vazios
#media: jalr zero, 0(ra)
#variancia: jalr zero, 0(ra)

media:
    add t0, zero, zero      # t0 será usado para armazenar a soma dos elementos
    add t1, zero, zero      # t1 será usado como contador
loop_media:
    beq t1, a1, end_media   # Se t1 == N, saia do loop
    lw t2, 0(a0)            # Carrega o valor atual do vetor em t2
    add t0, t0, t2          # Soma o valor de t2 a t0
    addi a0, a0, 4          # Move o ponteiro para o próximo inteiro (4 bytes)
    addi t1, t1, 1          # Incrementa o contador
    j loop_media            # Volta ao início do loop
end_media:
    div a0, t0, a1          # Divide a soma pelo número de elementos
    ret                     # Retorna para o endereço no registrador de retorno


covariancia:
    addi sp, sp, -12        # Aloca espaço na pilha para as médias e a soma das diferenças
    sw ra, 8(sp)            # Salva o endereço de retorno

    mv a1, a2               # Passa o número de elementos para calcular a média do primeiro vetor
    jal ra, media           # Chama a função media para o primeiro vetor
    sw a0, 4(sp)            # Salva a média do primeiro vetor na pilha
    mv a0, a1               # Muda o ponteiro para o segundo vetor

    mv a1, a2               # Passa o número de elementos para calcular a média do segundo vetor
    jal ra, media           # Chama a função media para o segundo vetor
    lw t0, 4(sp)            # Carrega a média do primeiro vetor de volta
    sw a0, 0(sp)            # Salva a média do segundo vetor na pilha

    # Inicializa somas e contadores
    add t1, zero, zero      # Contador
    add t2, zero, zero      # Soma das (xi - x)(yi - y)

loop_cov:
    beq t1, a2, end_cov     # Se t1 == N, saia do loop
    lw t3, 0(a0)            # Carrega xi
    lw t4, 0(a1)            # Carrega yi
    lw t5, 4(sp)            # Carrega a média x
    lw t6, 0(sp)            # Carrega a média y

    sub t3, t3, t5          # (xi - x)
    sub t4, t4, t6          # (yi - y)
    mul t3, t3, t4          # (xi - x)(yi - y)
    add t2, t2, t3          # Soma ao total

    addi a0, a0, 4          # Avança para o próximo elemento em vetor1
    addi a1, a1, 4          # Avança para o próximo elemento em vetor2
    addi t1, t1, 1          # Incrementa o contador
    j loop_cov              # Continua o loop

end_cov:
    addi a2, a2, -1         # N - 1, usando addi com um valor negativo
    div a0, t2, a2          # Divide a soma pelo (N - 1)
    lw ra, 8(sp)            # Restaura o endereço de retorno
    addi sp, sp, 12         # Libera a pilha
    ret                     # Retorna para o endereço no registrador de retorno

##### R2 END MODIFIQUE AQUI END #####

FIM: add t0, zero, s0
