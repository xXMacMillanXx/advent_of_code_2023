import os
import math

struct Galaxy {
	id int
	x int
	y int
}

fn (g Galaxy) str() string {
	return 'Galaxy ${g.id} at x: ${g.x} y: ${g.y}'
}

fn (g Galaxy) calc_distance(g2 Galaxy) int {
	x := math.abs(g.x - g2.x)
	y := math.abs(g.y - g2.y)
	return x + y
}

struct Image {
mut:
	coords [][]rune
	galaxies []Galaxy
	warps_x []int
	warps_y []int
}

fn print_2d_array[T](arr T) {
	for line in arr {
		for c in line {
			print(c.str())
		}
		println('')
	}
}

fn Image.new(s []string) Image {
	mut ret := Image{}
	for y, line in s {
		ret.coords << []rune{}
		for _, c in line {
			ret.coords[y] << c
		}
	}
	return ret
}

fn (mut i Image) expand() {
	mut y := 0
	for ; y < i.coords.len; y++ {
		if `#` !in i.coords[y] {
			i.warps_y << y
		}
	}
	mut x := 0
	for ; x < i.coords[0].len; x++ {
		mut check := []rune{}
		y = 0
		for ; y < i.coords.len; y++ {
			check << i.coords[y][x]
		}
		if `#` !in check {
			i.warps_x << x
		}
	}
}

fn (mut i Image) gather_galaxies(warp_speed int) {
	mut id := 1
	mut y_warp := 0
	mut x_warp := 0
	for y, line in i.coords {
		x_warp = 0
		if y in i.warps_y { y_warp += warp_speed-1 }
		for x, c in line {
			if x in i.warps_x { x_warp += warp_speed-1 }
			if c == `#` {
				i.galaxies << Galaxy {id, x_warp, y_warp}
				id++
			}
			x_warp++
		}
		y_warp++
	}
}

fn create_pairs[T](val []T) [][]T {
	mut ret := [][]T{}
	for i := 0; i < val.len - 1; i++ {
		for x := i+1; x < val.len; x++ {
			ret << [val[i], val[x]]
		}
	}
	return ret
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut img := Image.new(lines)
	img.expand()
	// print_2d_array(img.coords)
	img.gather_galaxies(1000000)
	gals := create_pairs(img.galaxies)
	mut res := i64(0)
	for pair in gals {
		res += pair[0].calc_distance(pair[1])
	}
	println(res)
}
