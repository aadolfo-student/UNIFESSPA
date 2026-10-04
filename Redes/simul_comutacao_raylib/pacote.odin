package main

import "core:container/queue"

Pacote :: struct {
	comutadores: queue.Queue(int), //lista de comutadores pelo qual o pacote já passou
	origem:      int, //id de origem do pacote
	destino:     int, //id de destino do pacote
	id:          int, //observe que o principal objetivo do id é informar qual a posição do pacote
	texto:       string, //informação que o pacote carrega
}

/*
Cria um novo pacote na memória, preenchendo seus campos básicos.
O histórico de comutadores (comutadores) inicia vazio.
*/
criar_pacote :: proc(origem, destino, id: int, texto: string) -> ^Pacote {
	p := new(Pacote)
	p.origem = origem
	p.destino = destino
	p.id = id
	p.texto = texto
	return p
}

liberar_pacote :: proc(pacote: ^Pacote) {
	queue.destroy(&pacote.comutadores)
	free(pacote)
}
