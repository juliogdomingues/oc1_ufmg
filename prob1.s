.data

##### R1 START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor: .word 1 2 3 4 5 6 7 8 9 10


##### R1 END MODIFIQUE AQUI END #####

.text
        add s0, zero, zero #Quantidade de testes em que seu programa passou
        la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 2
        jal ra, multiplos
        addi t0, zero, 5
        bne a0,t0,teste2
        addi s0,s0,1
teste2: la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 3
        jal ra, multiplos
        addi t0, zero, 3
        bne a0,t0, teste3
        addi s0,s0,1
        #beq zero,zero,FIM

##### R2 START MODIFIQUE AQUI START #####
# Testes próprios

teste3: la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 4
        jal ra, multiplos
        addi t0, zero, 2   # Esperado: 2 múltiplos de 4
        bne a0, t0, teste4
        addi s0, s0, 1

teste4: la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 5
        jal ra, multiplos
        addi t0, zero, 2   # Esperado: 2 múltiplos de 5
        bne a0, t0, teste5
        addi s0, s0, 1

teste5: la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 6
        jal ra, multiplos
        addi t0, zero, 1   # Esperado: 1 múltiplo de 6
        bne a0, t0, teste6
        addi s0, s0, 1

teste6:
        addi a2, zero, -2  
        jal ra, multiplos  
        addi t0, zero, 5   # Esperado: 5 múltiplos de -2
        bne a0, t0, FIM
        addi s0, s0, 1

#multiplos: jalr zero, 0(ra)

multiplos:
        addi t1, zero, 0    # t1 é o contador de múltiplos
        addi t2, zero, 0    # t2 é o índice atual no vetor
        add t3, a0, zero    # Copia o endereço inicial de a0 para t3

loop:   beq t2, a1, return  # Se t2 == a1, termina o loop
        lw t4, 0(t3)        # Carrega o elemento atual do vetor em t4
        addi t3, t3, 4      # Incrementa o ponteiro do vetor
        rem t5, t4, a2      # t5 = t4 % a2
        bnez t5, skip       # Se t5 != 0, pula para skip
        addi t1, t1, 1      # Incrementa o contador t1
skip:   addi t2, t2, 1      # Incrementa o índice t2
        j loop              # Volta para o início do loop

return: add a0, zero, t1    # Coloca o resultado em a0
        jr ra               # Retorna para o endereço de retorno



##### R2 END MODIFIQUE AQUI END #####

FIM: addi t0, s0, 0

