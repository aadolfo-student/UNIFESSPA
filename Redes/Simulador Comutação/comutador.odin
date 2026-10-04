package main

import "core:container/queue"

COD_OK :: 0
COD_NIL :: 1
COD_LIMITE :: 2

Comutador :: struct {
    id: int, //id do comutador, usado no histórico anti-loop dos pacotes
    vizinho: queue.Queue(^Comutador), //lista de comutadores ao qual este comutador se conecta
    usuarios: queue.Queue(^Usuario), //usuarios ao qual o comutador está conectado
    pacotes: queue.Queue(^Pacote), //lista de pacotes recebidos
}

/*
Verifica se um valor está presente em uma fila (iteração não-destrutiva).
Funciona para filas de int, ^Comutador e ^Usuario.
*/
fila_tem :: proc($T: typeid, f: ^queue.Queue(T), valor: T) -> bool {
    for i in 0..<queue.len(f^) {
        if queue.get_ptr(f, i)^ == valor {
            return true
        }
    }
    return false
}

/*
Adiciona um comutador c2 a lista de comutadores vizinhos de c1 (e vice-versa).
Retorna true caso a operação tenha sido bem sucedida, e false caso não.
*/
add_comutador :: proc(c1, c2: ^Comutador) -> bool {
    if c1 == nil || c2 == nil || c1 == c2 {
        return false
    }
    if fila_tem(^Comutador, &c1.vizinho, c2) {
        return false
    }
    queue.push_back(&c1.vizinho, c2)
    queue.push_back(&c2.vizinho, c1)
    return true
}

/*
Adiciona um usuario a lista de usuarios de um comutador.
Retorna true caso a operação tenha sido bem sucedida, e false caso não.
*/
add_usuario :: proc(c: ^Comutador, u: ^Usuario) -> bool {
    if c == nil || u == nil {
        return false
    }
    if u.comutador != nil {
        return false
    }
    if fila_tem(^Usuario, &c.usuarios, u) {
        return false
    }
    u.comutador = c
    queue.push_back(&c.usuarios, u)
    return true
}

/*
Envia um pacote de c1 para c2.
Só funciona se c2 for vizinho de c1.
*/
envia_pacote :: proc(c1, c2: ^Comutador, p: ^Pacote) -> bool {
    if c1 == nil || c2 == nil || p == nil {
        return false
    }
    if !fila_tem(^Comutador, &c1.vizinho, c2) {
        return false
    }
    queue.push_back(&c2.pacotes, p)
    return true
}

/*
Realiza a comutação dos pacotes por flooding.
Retorna COD_OK (0) em caso de sucesso, ou COD_NIL (1) se comu for nil.

Para cada pacote na fila:
  1. se este comutador já processou o pacote (id já está no histórico), descarta a cópia;
  2. caso contrário, registra o próprio id no histórico;
  3. se o usuário de destino está conectado aqui, entrega na caixa de entrada dele;
  4. senão, reenvia para todos os vizinhos ainda não visitados (flooding).

O histórico de ids evita loops e garante que a entrega no destino ocorra uma única vez.
*/
comutar :: proc(comu: ^Comutador) -> int {
    if comu == nil {
        return COD_NIL
    }

    for queue.len(comu.pacotes) > 0 {
        p := queue.pop_front(&comu.pacotes)

        if fila_tem(int, &p.comutadores, comu.id) {
            continue // cópia já processada por este comutador
        }
        queue.push_back(&p.comutadores, comu.id)

        entregue := false
        for i in 0..<queue.len(comu.usuarios) {
            u := queue.get_ptr(&comu.usuarios, i)^
            if u.id == p.destino {
                queue.push_back(&u.caixa_entrada, p)
                entregue = true
                break
            }
        }

        if !entregue {
            for i in 0..<queue.len(comu.vizinho) {
                viz := queue.get_ptr(&comu.vizinho, i)^
                if !fila_tem(int, &p.comutadores, viz.id) {
                    envia_pacote(comu, viz, p)
                }
            }
        }
    }

    return COD_OK
}
