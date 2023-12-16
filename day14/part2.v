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
	mut tracking := []int{}
	mut spin := 0
	// bring spin to beginning of cycling pattern
	for ; spin < 200; spin++ {
		board.spin()
		res := board.calc()
		if res in tracking {
			tracking = []int{}
			spin++
			break
		}
		tracking << res
	}
	// pre_offset := spin
	// find length of cycling pattern, while adding to spin
	for ; spin < 200; spin++ {
		board.spin()
		res := board.calc()
		if res in tracking {
			tracking << res
			spin++
			break
		} else {
			tracking << res
		}
	}
	// calc how many steps need to be taken to reach the same value as spinning the board 1000000000 times
	post_offset := (1000000000 - spin) % tracking.len
	// groups := (1000000000 - spin) / tracking.len
	// println('${groups} ${post_offset} ${tracking.len} ${pre_offset} ${spin - pre_offset}')
	for _ in 0..post_offset {
		board.spin()
		spin++
	}
	// println(spin + groups * tracking.len)
	println(board.calc())
}
