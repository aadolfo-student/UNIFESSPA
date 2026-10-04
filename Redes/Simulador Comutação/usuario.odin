package main

import "core:container/queue"
import "core:slice"
import "core:strings"

Usuario :: struct {
    id: int, //id do usuario
    comutador: ^Comutador, //Comutador ao qual o usuário está conectado
    caixa_entrada: queue.Queue(^Pacote), //pacotes entregues a este usuário
}

/*
Faz um usuário enviar uma mensagem para outro, pelo comutador ao qual está conectado.
A mensagem é dividida em pacotes, palavra por palavra.
Retorna true caso tudo ocorra bem.
*/
enviar_mensagem :: proc(origem, destino: ^Usuario, mensagem: string) -> bool {
    if origem == nil || destino == nil {
        return false
    }
    if origem.comutador == nil || destino.comutador == nil {
        return false
    }

    palavras := strings.split(mensagem, " ")
    defer delete(palavras)

    total := 0
    for i in 0..<len(palavras) {
        if palavras[i] == "" {
            continue
        }
        p := criar_pacote(origem.id, destino.id, total, palavras[i])
        queue.push_back(&origem.comutador.pacotes, p)
        total += 1
    }

    return total > 0
}

/*
Remonta a mensagem recebida de uma determinada origem a partir dos pacotes da caixa de entrada.
Consome (remove) da caixa de entrada os pacotes daquela origem.
Retorna a mensagem remontada e true; ou "" e false se a mensagem estiver incompleta ou ausente.
*/
receber_mensagem :: proc(u: ^Usuario, origem_id: int) -> (string, bool) {
    if u == nil {
        return "", false
    }

    coleta: [dynamic]^Pacote
    defer delete(coleta)

    n := queue.len(u.caixa_entrada)
    for _ in 0..<n {
        p := queue.pop_front(&u.caixa_entrada)
        if p.origem == origem_id {
            append(&coleta, p)
        } else {
            queue.push_back(&u.caixa_entrada, p)
        }
    }

    if len(coleta) == 0 {
        return "", false
    }

    slice.sort_by(coleta[:], proc(a, b: ^Pacote) -> bool {
        return a.id < b.id
    })

    // integridade: os ids devem ser 0, 1, ..., len-1 (sem lacunas)
    if coleta[0].id != 0 || coleta[len(coleta)-1].id != len(coleta)-1 {
        return "", false
    }

    textos := make([]string, len(coleta))
    defer delete(textos)
    for p, i in coleta {
        textos[i] = p.texto
    }

    return strings.join(textos, " "), true
}
