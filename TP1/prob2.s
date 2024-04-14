.data

##### R1 START MODIFIQUE AQUI START #####

#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor1: .word 1 2 3 4		# Primeiro vetor
vetor2: .word 1 1 1 1		# Segundo vetor
vetor3: .word -5 -1 -2 -4       # Vetor com valores negativos
vetor4: .word -1 -1 -1 -1       # Vetor uniforme com valores negativos
vetor5: .word 1000 0 0 0        # Vetor com um valor alto e zeros
vetor6: .word 0 0 0 0           # Vetor com todos elementos zero
vetor7: .word 4 3 2 1		# Vetor com valores decrescentes, inverso do vetor1

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
        beq zero,zero, FIM

##### R2 START MODIFIQUE AQUI START #####
# Esse espaço é para você escrever o código dos procedimentos. 
# Por enquanto eles estão vazios
#media: jalr zero, 0(ra)
media:
        addi t1, zero, 0                # Inicializa a soma dos elementos
        addi t2, zero, 0                # Inicializa o contador de índices
        beq a1, zero, fim_media         # Retorna zero se não há elementos
loop_media:
        beq t2, a1, calcula_media       # Verifica se todos os elementos foram processados
        slli t3, t2, 2                  # Calcula o deslocamento
        add t3, t3, a0                  # Ajusta o ponteiro para o elemento atual
        lw t4, 0(t3)                    # Carrega o elemento atual
        add t1, t1, t4                  # Adiciona o elemento à soma
        addi t2, t2, 1                  # Incrementa o contador de índices
        j loop_media                    # Salta de volta para o início do loop
calcula_media:
        div t1, t1, a1                  # Divide a soma pelo número de elementos
        add a0, zero, t1                # Retorna a média
        ret                             # Retorna para o endereço de chamada
fim_media:
        addi a0, zero, 0                # Retorna zero
        ret      

#variancia: jalr zero, 0(ra)
covariancia:
        addi sp, sp, -20                # Aloca espaço na pilha
        sw ra, 16(sp)                   # Salva o endereço de retorno
        sw a0, 12(sp)                   # Salva o endereço original de a0 (vetor1)
        sw a1, 8(sp)                    # Salva o endereço original de a1 (vetor2)

        mv a1, a2                       # Configura o número de elementos para vetor1
        jal ra, media                   # Calcula a média do vetor1
        sw a0, 4(sp)                    # Salva a média calculada do vetor1
        lw a0, 8(sp)                    # Restaura a1 para calcular sua média
        mv a1, a2                       # Configura o número de elementos para vetor2
        jal ra, media                   # Calcula a média do vetor2
        sw a0, 0(sp)                    # Salva a média calculada do vetor2

        lw a0, 12(sp)                   # Restaura a0 (vetor1)
        lw a1, 8(sp)                    # Restaura a1 (vetor2)

    	add t1, zero, zero              # Zera o contador
    	add t2, zero, zero              # Zera a soma

loop_cov:
        beq t1, a2, fim_cov             # Verifica se o contador alcançou N
        lw t3, 0(a0)                    # Carrega xi de a0
        lw t4, 0(a1)                    # Carrega yi de a1
        lw t5, 0(sp)                    # Carrega a média do vetor2
        lw t6, 4(sp)                    # Carrega a média do vetor1

        sub t3, t3, t6                  # Calcula (xi - média_x)
        sub t4, t4, t5                  # Calcula (yi - média_y)
        mul t3, t3, t4                  # Multiplica as diferenças
        add t2, t2, t3                  # Acumula o resultado

        addi a0, a0, 4                  # Avança para o próximo elemento de a0
        addi a1, a1, 4                  # Avança para o próximo elemento de a1
        addi t1, t1, 1                  # Incrementa o contador
        j loop_cov                      # Salta de volta para o início do loop

fim_cov:
        addi a2, a2, -1                 # Ajusta para N-1
        div a0, t2, a2                  # Divide a soma por N-1
        lw ra, 16(sp)                   # Restaura ra
        addi sp, sp, 20                 # Libera espaço na pilha
        ret                             # Retorna para o endereço de chamada

# Testes próprios (para rodar, comentar última linha dos testes originais)

# Testes 3 e 4: Valores negativos
teste3:
        la a0, vetor3
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, -3       # Espera média de -3 para vetor3
        bne a0, t0, teste4
        addi s0, s0, 1
teste4:
        la a0, vetor4
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, -1       # Espera média de -1 para vetor4
        bne a0, t0, teste5
        addi s0, s0, 1

# Testes 5 e 6: Elementos zero e valores altos
teste5:
        la a0, vetor5
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 250      # Espera média de 250 para vetor5
        bne a0, t0, teste6
        addi s0, s0, 1
teste6:
        la a0, vetor6
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 0        # Espera média de 0 para vetor6
        bne a0, t0, teste7
        addi s0, s0, 1

# Testes 7 e 8: Covariância
teste7:
        la a0, vetor1
        la a1, vetor2
        addi a2, zero, 4
        jal ra, covariancia
        mv t1, a0               # Armazena o resultado para verificar
        li t0, 0	        # Espera média de 0 para os vetores 1 e 2
        bne a0, t0, teste8      # Pula se o resultado não for o esperado
        addi s0, s0, 1

teste8:
        la a0, vetor1
        la a1, vetor7
        addi a2, zero, 4
        jal ra, covariancia
        mv t1, a0               # Armazena o resultado para verificar
        li t0, -1               # Espera média -1 para os vetores 1 e 7, considerando arredondamento pela aritmética inteira
        bne a0, t0, FIM         # Pula se o resultado não for o esperado
        addi s0, s0, 1
        beq zero,zero,FIM

##### R2 END MODIFIQUE AQUI END #####

FIM: add t0, zero, s0
