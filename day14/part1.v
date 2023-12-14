import os

struct Board {
mut:
	layout [][]rune
}

fn Board.new(lines []string) Board {
	mut ret := Board{}
	for y, line in lines {
		ret.layout << []rune{}
		for c in line {
			ret.layout[y] << c
		}
	}
	return ret
}

fn (mut b Board) tilt_north() {
	for x := 0; x < b.layout[0].len; x++ {
		mut count := 0
		mut y := b.layout.len - 1
		for ; y >= 0; y-- {
			if b.layout[y][x] == `O` {
				b.layout[y][x] = `.`
				count++
				continue
			}
			if b.layout[y][x] == `#` {
				for ; count > 0; count-- {
					b.layout[y+count][x] = `O`
				}
			}
		}
		for ; count > 0; count-- {
			b.layout[y+count][x] = `O`
		}
	}
}

fn (b Board) calc() int {
	mut ret := 0
	for i, line in b.layout {
		ret += line.filter(it == `O`).len * (b.layout.len - i)
	}
	return ret
}

fn print_arr[T](arr [][]T) {
	for line in arr {
		for c in line {
			print(c)
		}
		println('')
	}
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut board := Board.new(lines)
	board.tilt_north()
	println(board.calc())
}
