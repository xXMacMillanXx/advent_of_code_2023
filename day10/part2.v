import os

enum Direction {
	top
	right
	bottom
	left
}

fn (d Direction) reverse() Direction {
	return match d {
		.top { .bottom }
		.bottom { .top }
		.left { .right }
		.right { .left }
	}
}

fn (d Direction) to_coord_val() Point {
	return match d {
		.top { Point {-1, 0} }
		.bottom { Point {1, 0} }
		.left { Point {0, -1} }
		.right { Point {0, 1} }
	}
}

fn possible_directions(r rune) []Direction {
	match r {
		`|` { return [.top, .bottom] }
		`-` { return [.left, .right] }
		`L` { return [.top, .right] }
		`J` { return [.left, .top] }
		`7` { return [.left, .bottom] }
		`F` { return [.right, .bottom] }
		else {}
	}
	return []Direction{}
}

fn directions_to_rune(dir []Direction) rune {
	if Direction.top in dir && Direction.bottom in dir { return `|` }	
	if Direction.left in dir && Direction.right in dir { return `-` }	
	if Direction.top in dir && Direction.right in dir { return `L` }	
	if Direction.left in dir && Direction.top in dir { return `J` }	
	if Direction.left in dir && Direction.bottom in dir { return `7` }	
	if Direction.right in dir && Direction.bottom in dir { return `F` }
	return `.`	
}

struct Point {
mut:
	y int
	x int
}

fn (a Point) + (b Point) Point {
	return Point { a.y + b.y, a.x + b.x }
}

fn (a Point) == (b Point) bool {
	if a.x == b.x && a.y == b.y { return true }
	else { return false }
}

struct Map {
mut:
	layout [][]rune
	current Point
	came_from Direction
	origin Point
	start_is rune
}

fn Map.new(layout []string) Map {
	mut r_layout := [][]rune{}
	for l in layout {
		mut r_line := []rune{}
		for c in l {
			r_line << c
		}
		r_layout << r_line
	}
	mut ret := Map{ layout: r_layout }
	outer: for y, line in layout {
		for x, cha in line {
			if cha == `S` {
				ret.current = Point { y, x }
				ret.origin = Point { y, x }
				break outer
			}
		}
	}
	ret.came_from = start_directions(ret.current, layout)[0]
	ret.start_is = directions_to_rune(start_directions(ret.current, layout))
	return ret
}

fn (mut m Map) mark_step() {
	mut r := `.`
	if m.current == m.origin {
		r = m.start_is
	} else {
		r = m.layout[m.current.y][m.current.x]
	}

	dirs := possible_directions(r).filter(it != m.came_from)
	offset := dirs[0].to_coord_val()

	m.layout[m.current.y][m.current.x] = `#`
	m.came_from = dirs[0].reverse()
	m.current += offset
}

fn (mut m Map) mark_loop() {
	m.mark_step()

	for m.current != m.origin {
		m.mark_step()
	}
}

fn check_valid(p Point, max_x int, max_y int) bool {
	if p.x >= 0 && p.x < max_x && p.y >= 0 && p.y < max_y {
		return true
	}
	return false
}

fn flood_fill_rec(mut layout [][]rune, fill rune, origin Point, wall rune) {
	if origin.x < 0 || origin.x >= layout[0].len || origin.y < 0 || origin.y >= layout.len { return }
	if layout[origin.y][origin.x] != wall && layout[origin.y][origin.x] != fill {
		layout[origin.y][origin.x] = fill

		flood_fill_rec(mut layout, fill, origin + Point { -1, 0 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { 1, 0 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { 0, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { 0, 1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { -1, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { 1, 1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { 1, -1 }, wall)
		flood_fill_rec(mut layout, fill, origin + Point { -1, 1 }, wall)
	}
}

fn start_directions(p Point, layout []string) []Direction {
	mut ret := []Direction{}
	if Direction.bottom in possible_directions(layout[p.y-1][p.x]) { ret << .top }
	if Direction.top in possible_directions(layout[p.y+1][p.x]) { ret << .bottom }
	if Direction.right in possible_directions(layout[p.y][p.x-1]) { ret << .left }
	if Direction.left in possible_directions(layout[p.y][p.x+1]) { ret << .right }
	return ret
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut m := Map.new(lines)
	m.mark_loop()
	flood_fill_rec(mut m.layout, `~`, Point {0, 0}, `#`)
	mut res := 0
	for r_l in m.layout {
		for r_c in r_l {
			print(r_c)
			if r_c != `#` && r_c != `~` { res++ }
		}
		println('')
	}
	println(res) // unfinished, flood fill ignores squeeze through part
}
