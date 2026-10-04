package main

import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:strings"
import rl "vendor:raylib"

angulo_poligono :: proc(lados: int) -> int {
	soma := (lados - 2) * 180
	resultado := 180 - (soma / lados)
	return resultado
}

random_rect_position :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	return {
		rand.float32_range(0.0, rect.width) + rect.x,
		rand.float32_range(0.0, rect.height) + rect.y,
	}
}

render_comutadores :: proc(comutadores: ..^Comutador) {
	angulo := angulo_poligono(len(comutadores))
	for comutador, index in comutadores {
		comutador.position =
			{f32(rl.GetRenderWidth() / 2), f32(rl.GetRenderHeight() / 2)} -
			{
					90 * (math.cos(f32(angulo * index + 45) * math.RAD_PER_DEG)),
					90 * (math.sin(f32(angulo * index + 45) * math.RAD_PER_DEG)),
				}
		render_comutador(comutador)
	}
}

render_usuarios :: proc(usuarios: ..^Usuario) {
	for usuario in usuarios {
		render_usuario(usuario)
	}
}

render_comutador :: proc(comutador: ^Comutador) {
	for i in 0 ..< queue.len(comutador.vizinhos) {
		vizinho := queue.get(&comutador.vizinhos, i)
		rl.DrawLineEx(comutador.position, vizinho.position, 3.0, rl.DARKBLUE)
	}

	render_pacotes(comutador.pacotes, comutador.position - {0, 30})

	rl.DrawCircleV(comutador.position, 10.0, rl.BLUE)
}

render_usuario :: proc(usuario: ^Usuario) {
	if usuario.comutador != nil {
		rl.DrawLineEx(usuario.position, usuario.comutador.position, 3.0, rl.DARKGRAY)
	}

	user := fmt.ctprintf("Usuario %v", usuario.id)
	render_pacotes(usuario.caixa_entrada, usuario.position + {0, -30})
	rl.DrawCircleV(usuario.position, 10.0, rl.GREEN)
	rl.DrawTextEx(rl.GetFontDefault(), user, usuario.position + {0.0, 10.0}, 12.0, 1.0, rl.GREEN)
}

render_pacotes :: proc(pacotes: queue.Queue(^Pacote), position: rl.Vector2) {
	pacotes := pacotes
	texto_pacotes := make([]string, queue.len(pacotes))
	for i in 0 ..< queue.len(pacotes) {
		pacote := queue.get(&pacotes, i)
		texto_pacotes[i] = pacote.texto
	}

	result := strings.join(texto_pacotes, "| |", allocator = context.temp_allocator)
	cstr := strings.clone_to_cstring(result, allocator = context.temp_allocator)
	rl.DrawTextEx(rl.GetFontDefault(), cstr, position, 12.0, 1.0, rl.GRAY)
}
