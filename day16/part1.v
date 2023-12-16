import os

enum TileType {
	mirror
	split
	path
}

struct Tile {
	typ TileType
	sym rune
mut:
	is_energized bool
}

fn Tile.new(tt TileType, r rune) Tile {
	return Tile { typ: tt, sym: r }
}

struct Vec {
mut:
	x int
	y int
}

fn (a Vec) + (b Vec) Vec {
	return Vec{ a.x+b.x, a.y+b.y }
}

type Layout = [][]Tile

fn (l Layout) prnt() {
	for line in l {
		for t in line {
			if t.is_energized {
				print('#')
			} else {
				print(t.sym)
			}
		}
		println('')
	}
}

struct Ray {
mut:
	pos Vec
	dir Vec
	layout Layout
	ended bool
}

fn Ray.new(l Layout) Ray {
	return Ray { Vec{0,0}, Vec{1,0}, l, false }
}

fn in_bounds(v Vec, l Layout) bool {
	if v.x >= 0 && v.x < l[0].len && v.y >= 0 && v.y < l.len {
		return true
	}
	return false
}

fn (mut r Ray) energize() {
	r.tile().is_energized = true
}

fn (r Ray) tile() &Tile {
	return &r.layout[r.pos.y][r.pos.x]
}

fn (mut r Ray) move() {
	check := r.pos + r.dir
	if in_bounds(check, r.layout) {
		r.pos += r.dir
	} else {
		r.ended = true
	}
}

fn (mut r Ray) split() Ray {
	c := r.tile().sym
	mut ret := Ray{ Vec{0,0}, Vec{0,0}, r.layout, true }
	match c {
		`|` {
			if r.dir.x == 1 || r.dir.x == -1 {
				if in_bounds(r.pos + Vec{0,1}, r.layout) {
					ret = Ray{ Vec{r.pos.x, r.pos.y+1}, Vec{0,1}, r.layout, false }
				}
				r.dir = Vec{0,-1}
			}
		}
		`-` {
			if r.dir.y == 1 || r.dir.y == -1 {
				if in_bounds(r.pos + Vec{-1,0}, r.layout) {
					ret = Ray{ Vec{r.pos.x-1, r.pos.y}, Vec{-1,0}, r.layout, false }
				}
				r.dir = Vec{1,0}
			}
		}
		else {}
	}
	return ret
}

fn (mut r Ray) mirror() {
	c := r.tile().sym
	match c {
		`/` {
			if r.dir.x == 1 { r.dir = Vec{0,-1} }
			else if r.dir.x == -1 { r.dir = Vec{0,1} }
			else if r.dir.y == 1 { r.dir = Vec{-1,0} }
			else if r.dir.y == -1 { r.dir = Vec{1,0} }
		}
		`\\` {
			if r.dir.x == 1 { r.dir = Vec{0,1} }
			else if r.dir.x == -1 { r.dir = Vec{0,-1} }
			else if r.dir.y == 1 { r.dir = Vec{1,0} }
			else if r.dir.y == -1 { r.dir = Vec{-1,0} }
		}
		else {}
	}
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut layout := Layout([][]Tile{})
	for y, line in lines {
		layout << []Tile{}
		for c in line {
			mut tt := TileType.path
			match c {
				`/`, `\\` { tt = .mirror }
				`|`, `-` { tt = .split }
				else { tt = .path }
			}
			layout[y] << Tile.new(tt, c)
		}
	}
	mut rays := []Ray{}
	rays << Ray.new(&layout)
	for rays.len > 0 {
		for mut ray in rays {
			if ray.ended {
				rays.delete(rays.index(ray))
				continue
			}
			match ray.tile().typ {
				.mirror {
					ray.mirror()
				}
				.split {
					if !ray.tile().is_energized {
						rays << ray.split()
					}
				}
				.path {}
			}
			ray.energize()
			ray.move()
		}
		// layout.prnt()
		// println('')
	}
	mut res := 0
	for line in layout {
		for tile in line {
			if tile.is_energized {
				res++
			}
		}
	}
	println(res) // I have no idea, why the example works, but the real input doesn't.
}
