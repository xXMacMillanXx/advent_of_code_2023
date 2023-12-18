import os
import gx

enum MoveDirection {
	up right down left
}

fn MoveDirection.convert(s string) MoveDirection {
	return match s {
		'U' { .up }
		'R' { .right }
		'D' { .down }
		'L' { .left }
		else { .down }
	}
}

struct Tile {
mut:
	val rune = `.`
	color gx.Color = gx.black
}

fn (t Tile) str() string {
	return t.val.str()
}

fn Tile.new(r rune, web_color string) Tile {
	hex_str := '0x' + web_color[1..]
	color := gx.hex(hex_str.int())
	return Tile { r, color }
}

struct Position {
mut:
	x int
	y int
}

fn (a Position) + (b Position) Position {
	return Position{ a.x+b.x, a.y+b.y }
}

struct Plan {
mut:
	layout [][]Tile
	pos Position
}

fn Plan.new() Plan {
	mut layout := [][]Tile{}
	layout << []Tile{}
	return Plan { layout, Position{0,0} }
}

fn (mut p Plan) prep_position() {
	if p.pos.y < 0 {
		p.layout.insert(0, []Tile{ len: p.layout[p.pos.y+1].len, init: Tile{} })
		p.pos.y += 1
	}
	if p.pos.y >= p.layout.len {
		p.layout << []Tile{ len: p.layout[p.pos.y-1].len, init: Tile{} }
	}
	for p.pos.x >= p.layout[p.pos.y].len {
		p.layout[p.pos.y] << Tile{}
	}
	for p.pos.x < 0 {
		for mut line in p.layout {
			line.insert(0, Tile{})
		}
		p.pos.x += 1
	}
}

fn (mut p Plan) move(dir MoveDirection, color string) {
	match dir {
		.up {p.pos.y -= 1}
		.right {p.pos.x += 1}
		.down {p.pos.y += 1}
		.left {p.pos.x -= 1}
	}
	p.prep_position()
	p.layout[p.pos.y][p.pos.x] = Tile.new(`#`, color)
}

fn (p Plan) get_tile(pos Position) !Tile {
	if pos.x >= 0 && pos.x < p.layout[pos.y].len && pos.y >= 0 && pos.y < p.layout.len {
		return p.layout[pos.y][pos.x]
	}
	return error('Tile out of bounds!')
}

fn (p Plan) skip(po Position, r rune) int {
	mut change := 0
	mut pos := po
	for p.layout[pos.y][pos.x].val == r {
		if pos.x + 1 < p.layout[pos.y].len {
			pos.x += 1
			change++
		}
	}
	return change
}

fn flood_fill_rec(mut layout [][]Tile, fill rune, origin Position, wall rune) {
	if origin.x < 0 || origin.x >= layout[origin.y].len || origin.y < 0 || origin.y >= layout.len { return }
	if layout[origin.y][origin.x].val != wall && layout[origin.y][origin.x].val != fill {
		layout[origin.y][origin.x] = Tile.new(fill, '#000000')

		flood_fill_rec(mut layout, fill, origin + Position { -1, 0 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { 1, 0 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { 0, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { 0, 1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { -1, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { 1, 1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { 1, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Position { -1, 1 }, wall)
	}
}

fn (mut p Plan) fill() {
	mut pos := Position{0,p.layout.len/2}
	mut tile := Tile{}
	tile = p.get_tile(Position{pos.x,pos.y}) or { Tile{} }
	if tile.val == `.` {
		pos.x += p.skip(Position{pos.x,pos.y}, `.`)
	}
	tile = p.get_tile(Position{pos.x,pos.y}) or { Tile{} }
	if tile.val == `#` {
		pos.x += p.skip(Position{pos.x,pos.y}, `#`)
	}
	flood_fill_rec(mut p.layout, `#`, pos, `#`)
}

fn print_2d_array[T](arr [][]T) {
	for line in arr {
		for c in line {
			print(c)
		}
		println('')
	}
}

fn main() {
	lines := os.read_lines('input.txt')!

	mut plan := Plan.new()
	for line in lines {
		sp := line.split(' ') // dir, count, hex_color
		for _ in 0..sp[1].int() {
			plan.move(MoveDirection.convert(sp[0]), sp[2][1..sp[2].len-1])
		}
	}
	plan.fill()
	print_2d_array(plan.layout)

	mut res := 0
	for line in plan.layout {
		for tile in line {
			if tile.val == `#` {
				res++
			}
		}
	}
	println(res)
}
