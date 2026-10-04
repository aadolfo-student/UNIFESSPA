package main

import "core:container/queue"
import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

MAX_ITERS :: 1000


/*
Executa a comutação em todos os comutadores até que não haja mais pacotes pendentes.
Retorna COD_OK (0) quando a rede se estabiliza, ou COD_LIMITE (2) se estourar o teto de iterações.
*/
rodar_rede :: proc(comutadores: []^Comutador) -> int {
	for _ in 0 ..< MAX_ITERS {
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

iters := 0
rodar_rede_nb :: proc(comutadores: []^Comutador) -> int {
	if iters < MAX_ITERS {
		iters += 1
		pendente := false
		for c in comutadores {
			if queue.len(c.pacotes) > 0 {
				pendente = true
				comutar_nb(c)
			}
		}
		if !pendente {
			return COD_OK
		}
	}
	return COD_LIMITE
}

comutar_nb :: proc(comu: ^Comutador) -> int {
	if comu == nil {
		return COD_NIL
	}

	if queue.len(comu.pacotes) > 0 {
		p := queue.pop_front(&comu.pacotes)

		if fila_tem(int, &p.comutadores, comu.id) {
			queue.push_front(&comu.pacotes, p)
			return COD_ATRAVESSADO // cópia já processada por este comutador
		}
		queue.push_back(&p.comutadores, comu.id)

		entregue := false
		for i in 0 ..< queue.len(comu.usuarios) {
			u := queue.get(&comu.usuarios, i)
			if u.id == p.destino {
				queue.push_back(&u.caixa_entrada, p)
				entregue = true
				break
			}
		}

		if !entregue {
			for i in 0 ..< queue.len(comu.vizinhos) {
				viz := queue.get(&comu.vizinhos, i)
				if !fila_tem(int, &p.comutadores, viz.id) {
					envia_pacote(comu, viz, p)
				}
			}
		}
	}

	return COD_OK
}


main :: proc() {
	// when ODIN_DEBUG {
	// 	track: mem.Tracking_Allocator
	// 	mem.tracking_allocator_init(&track, context.allocator)
	// 	context.allocator = mem.tracking_allocator(&track)

	// 	defer {
	// 		if len(track.allocation_map) > 0 {
	// 			fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
	// 			for _, entry in track.allocation_map {
	// 				fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
	// 			}
	// 		}
	// 		mem.tracking_allocator_destroy(&track)
	// 	}
	// }

	rl.InitWindow(1280, 720, "Comutação de Pacotes")
	defer rl.CloseWindow()

	// comutadores
	c1 := new_comutador(101)
	defer free_comutador(c1)
	c2 := new_comutador(102)
	defer free_comutador(c2)
	c3 := new_comutador(103)
	defer free_comutador(c3)
	c4 := new_comutador(104)
	defer free_comutador(c4)

	// topologia em anel: c1-c2-c3-c4-c1
	add_comutador(c1, c2)
	add_comutador(c2, c3)
	add_comutador(c3, c4)
	add_comutador(c4, c1)

	// usuários
	u1 := new_usuario(1)
	defer free_usuario(u1)
	u2 := new_usuario(2)
	defer free_usuario(u2)
	u3 := new_usuario(3)
	defer free_usuario(u3)
	u4 := new_usuario(4)
	defer free_usuario(u4)

	add_usuario(c1, u1)
	add_usuario(c2, u2)
	add_usuario(c3, u3)
	add_usuario(c4, u4)

	comutadores := []^Comutador{c1, c2, c3, c4}

	mensagem := "ola rede de comutacao de pacotes"
	fmt.println("Enviando de U", u1.id, "para U", u3.id, ": \"", mensagem, "\"", sep = "")

	if !enviar_mensagem(u1, u3, mensagem) {
		fmt.println("Falha no envio da mensagem.")
		return
	}

	if rodar_rede(comutadores) != COD_OK {
		fmt.println("A rede não estabilizou dentro do limite de iterações.")
		return
	}

	fmt.println("\nCaixa de entrada de U3:", queue.len(u3.caixa_entrada), "pacote(s)")
	for i in 0 ..< queue.len(u3.caixa_entrada) {
		p := queue.get(&u3.caixa_entrada, i)
		fmt.print("  pacote id=", p.id, " texto=\"", p.texto, "\" historico=")
		for j in 0 ..< queue.len(p.comutadores) {
			if j > 0 {
				fmt.print(" -> ")
			}
			fmt.print(queue.get(&p.comutadores, j))
		}
		fmt.println()
	}

	recebida, ok := receber_mensagem(u3, u1.id)
	if ok {
		fmt.println("\nMensagem remontada em U3: \"", recebida, "\"")
	} else {
		fmt.println("\nMensagem incompleta ou ausente em U3.")
	}

	for !rl.WindowShouldClose() {
		if rl.GuiButton({20, 20, 100, 20}, "Iterar") {
			rodar_rede_nb(comutadores)
		}
		if rl.GuiButton({20, 50, 150, 20}, "Enviar de U1 para U3") {
			enviar_mensagem(u1, u3, mensagem)
		}
		if rl.GuiButton({20, 80, 150, 20}, "Enviar de U2 para U4") {
			enviar_mensagem(u2, u4, mensagem)
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		render_comutadores(..comutadores)
		render_usuarios(u1, u2, u3, u4)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
