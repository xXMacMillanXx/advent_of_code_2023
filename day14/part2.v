import os

enum Tilt {
	north
	west
	south
	east
}

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

fn (mut b Board) tilt(t Tilt) {
	match t {
		.north {
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
		.west {
			for y := 0; y < b.layout.len; y++ {
				mut count := 0
				mut x := b.layout[0].len - 1
				for ; x >= 0; x-- {
					if b.layout[y][x] == `O` {
						b.layout[y][x] = `.`
						count++
						continue
					}
					if b.layout[y][x] == `#` {
						for ; count > 0; count-- {
							b.layout[y][x+count] = `O`
						}
					}
				}
				for ; count > 0; count-- {
					b.layout[y][x+count] = `O`
				}
			}
		}
		.south {
			for x := 0; x < b.layout[0].len; x++ {
				mut count := 0
				mut y := 0
				for ; y < b.layout.len; y++ {
					if b.layout[y][x] == `O` {
						b.layout[y][x] = `.`
						count++
						continue
					}
					if b.layout[y][x] == `#` {
						for ; count > 0; count-- {
							b.layout[y-count][x] = `O`
						}
					}
				}
				for ; count > 0; count-- {
					b.layout[y-count][x] = `O`
				}
			}
		}
		.east {
			for y := 0; y < b.layout.len; y++ {
				mut count := 0
				mut x := 0
				for ; x < b.layout[0].len; x++ {
					if b.layout[y][x] == `O` {
						b.layout[y][x] = `.`
						count++
						continue
					}
					if b.layout[y][x] == `#` {
						for ; count > 0; count-- {
							b.layout[y][x-count] = `O`
						}
					}
				}
				for ; count > 0; count-- {
					b.layout[y][x-count] = `O`
				}
			}
		}
	}
}

fn (mut b Board) spin() {
	b.tilt(.north)
	b.tilt(.west)
	b.tilt(.south)
	b.tilt(.east)
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
	// at a certain stage, the pattern of calc() keeps repeating
	// so one of the numbers in the repeating pattern has to be the solution
	// now I just need to find out, how to best upscale, once I found the repeating pattern.
	// TODO
	// track calc solution till number repeats, track till second number repeat, try to scale index to or close to 1000000000
	mut tracking := []int{}
	mut i := 1
	for ; i < 200; i++ { // 1000000000
		board.spin()
		res := board.calc()
		if res in tracking {
			tracking = []int{}
			break
		}
		tracking << res
	}
	x := i
	for ; i < 200; i++ { // 1000000000
		board.spin()
		res := board.calc()
		if res in tracking {
			tracking << res
			break
		} else {
			tracking << res
		}
	}
	for (1000000000 - i) % (tracking.len - 1) != 0 {
		board.spin()
		i++
	}
	println(board.calc()) // no right solution yet, probably a problem with the index (wrong index)
}
