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
	for y := 1; y < b.layout.len; y++ {
		for x := 0; x < b.layout[y].len; x++ {
			if b.layout[y][x] == `O` {
				mut ray := y - 1
				for ; ray >= 0; ray-- {
					if b.layout[ray][x] == `O` || b.layout[ray][x] == `#` {
						ray++
						break
					}
				}
				if ray == -1 { ray = 0 }
				if ray == y { continue }
				b.layout[ray][x] = `O`
				b.layout[y][x] = `.`
			}
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
