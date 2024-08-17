#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <queue>
#include <cstdio>

using namespace std;

// Estrutura representando uma linha de cache
struct LinhaCache {
    bool valida = false;
    unsigned int tag = 0;
};

// Função para imprimir o estado atual da cache no arquivo de saída
void imprimirCache(const vector<vector<LinhaCache>> &cache, int numConjuntos, int associatividade, ofstream &saida) {
    saida << "================" << endl;
    saida << "IDX V ** ADDR **" << endl;
    int idx = 0;
    for (int conjunto = 0; conjunto < numConjuntos; conjunto++) {
        for (int linha = 0; linha < associatividade; linha++) {
            char buffer[100];
            if (cache[conjunto][linha].valida) {
                sprintf(buffer, "%03d 1 0x%08X", idx++, cache[conjunto][linha].tag);
            } else {
                sprintf(buffer, "%03d 0", idx++);
            }
            saida << buffer << endl;
        }
    }
}

// Função para processar um acesso à memória
void processarAcesso(unsigned int endereco, int tamanhoLinha, int numConjuntos, int associatividade, 
                     vector<vector<LinhaCache>> &cache, vector<queue<int>> &filaSubstituicao, 
                     int &hits, int &misses) {
    int shiftBits = log2(tamanhoLinha);
    unsigned int tag = endereco >> shiftBits;
    unsigned int idxConjunto = (tag % numConjuntos);

    bool hit = false;

    // Verificação se o bloco já está na cache (hit)
    for (auto &linha : cache[idxConjunto]) {
        if (linha.valida && linha.tag == tag) {
            hit = true;
            break;
        }
    }

    if (hit) {
        hits++;
    } else {
        misses++;

        // Gerenciamento FIFO para substituição de linhas
        if (filaSubstituicao[idxConjunto].size() < static_cast<size_t>(associatividade)) {
            int novaLinhaIdx = filaSubstituicao[idxConjunto].size();
            cache[idxConjunto][novaLinhaIdx].valida = true;
            cache[idxConjunto][novaLinhaIdx].tag = tag;
            filaSubstituicao[idxConjunto].push(novaLinhaIdx);
        } else {
            int substituirIdx = filaSubstituicao[idxConjunto].front();
            filaSubstituicao[idxConjunto].pop();
            cache[idxConjunto][substituirIdx].valida = true;
            cache[idxConjunto][substituirIdx].tag = tag;
            filaSubstituicao[idxConjunto].push(substituirIdx);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        cerr << "Uso: ./simulador <tamanho_cache> <tamanho_linha> <associatividade> <arquivo_entrada>" << endl;
        return 1;
    }

    int tamanhoCache = stoi(argv[1]);
    int tamanhoLinha = stoi(argv[2]);
    int associatividade = stoi(argv[3]);
    string arquivoEntrada = argv[4];

    // Verificação dos argumentos
    if (tamanhoCache <= 0 || tamanhoLinha <= 0 || associatividade <= 0) {
        cerr << "Erro: Todos os parâmetros devem ser números positivos." << endl;
        return 1;
    }

    int numLinhas = tamanhoCache / tamanhoLinha;
    int numConjuntos = numLinhas / associatividade;

    // Verificação para evitar erros de configuração
    if (numConjuntos <= 0) {
        cerr << "Erro: Configuração de cache inválida." << endl;
        return 1;
    }

    vector<vector<LinhaCache>> cache(numConjuntos, vector<LinhaCache>(associatividade));
    vector<queue<int>> filaSubstituicao(numConjuntos);
    int hits = 0, misses = 0;

    ifstream entrada(arquivoEntrada);
    ofstream saida("output.txt");

    // Verificação para garantir que o arquivo de entrada foi aberto corretamente
    if (!entrada.is_open()) {
        cerr << "Erro: Não foi possível abrir o arquivo de entrada." << endl;
        return 1;
    }

    unsigned int endereco;
    while (entrada >> hex >> endereco) {
        processarAcesso(endereco, tamanhoLinha, numConjuntos, associatividade, cache, filaSubstituicao, hits, misses);
        imprimirCache(cache, numConjuntos, associatividade, saida);
    }

    // Imprime as estatísticas de hits e misses
    saida << endl << "#hits: " << hits << endl;
    saida << "#miss: " << misses << endl;

    return 0;
}
