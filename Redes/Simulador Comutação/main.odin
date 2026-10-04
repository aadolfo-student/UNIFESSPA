package main

import "core:fmt"
import "core:container/queue"

MAX_ITERS :: 1000

/*
Executa a comutação em todos os comutadores até que não haja mais pacotes pendentes.
Retorna COD_OK (0) quando a rede se estabiliza, ou COD_LIMITE (2) se estourar o teto de iterações.
*/
rodar_rede :: proc(comutadores: []^Comutador) -> int {
    for _ in 0..<MAX_ITERS {
        pendente := false
        for c in comutadores {
            if queue.len(c.pacotes) > 0 {
                pendente = true
                comutar(c)
            }
        }
        if !pendente {
            return COD_OK
        }
    }
    return COD_LIMITE
}

main :: proc() {
    // comutadores
    c1 := new(Comutador); c1.id = 101
    c2 := new(Comutador); c2.id = 102
    c3 := new(Comutador); c3.id = 103
    c4 := new(Comutador); c4.id = 104

    // topologia em anel: c1-c2-c3-c4-c1
    add_comutador(c1, c2)
    add_comutador(c2, c3)
    add_comutador(c3, c4)
    add_comutador(c4, c1)

    // usuários
    u1 := new(Usuario); u1.id = 1
    u2 := new(Usuario); u2.id = 2
    u3 := new(Usuario); u3.id = 3
    u4 := new(Usuario); u4.id = 4

    add_usuario(c1, u1)
    add_usuario(c2, u2)
    add_usuario(c3, u3)
    add_usuario(c4, u4)

    comutadores := []^Comutador{c1, c2, c3, c4}

    mensagem := "ola rede de comutacao de pacotes"
    fmt.println("Enviando de U", u1.id, "para U", u3.id, ": \"", mensagem, "\"")

    if !enviar_mensagem(u1, u3, mensagem) {
        fmt.println("Falha no envio da mensagem.")
        return
    }

    if rodar_rede(comutadores) != COD_OK {
        fmt.println("A rede não estabilizou dentro do limite de iterações.")
        return
    }

    fmt.println("\nCaixa de entrada de U3:", queue.len(u3.caixa_entrada), "pacote(s)")
    for i in 0..<queue.len(u3.caixa_entrada) {
        p := queue.get_ptr(&u3.caixa_entrada, i)^
        fmt.print("  pacote id=", p.id, " texto=\"", p.texto, "\" historico=")
        for j in 0..<queue.len(p.comutadores) {
            if j > 0 {
                fmt.print(" -> ")
            }
            fmt.print(queue.get_ptr(&p.comutadores, j)^)
        }
        fmt.println()
    }

    recebida, ok := receber_mensagem(u3, u1.id)
    if ok {
        fmt.println("\nMensagem remontada em U3: \"", recebida, "\"")
    } else {
        fmt.println("\nMensagem incompleta ou ausente em U3.")
    }
}
