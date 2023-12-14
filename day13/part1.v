import os
import math

struct Pattern {
	layout []string
	layout_rot []string
	rows []int
	columns []int
}

fn Pattern.new(lines []string) Pattern {
	mut rot := [][]rune{ len: lines[0].len, init: []rune{} }
	mut row := []int{}
	for y := 0; y < lines.len; y++ {
		row << to_value(lines[y])
		for x := 0; x < lines[0].len; x++ {
			rot[x] << lines[y][x]
		}
	}
	mut rot_s := []string{}
	mut col := []int{}
	for r_line in rot {
		rot_s << r_line.string()
		col << to_value(r_line.string())
	}
	return Pattern { lines, rot_s, row, col }
}

fn to_value(s string) int {
	mut ret := 0
	for i, c in s {
		if c == `#` {
			ret += int(math.pow(2, i))
		}
	}
	return ret
}

fn (p Pattern) str() string {
	return p.layout.join('\n')
}

fn (p Pattern) str_rot() string {
	return p.layout_rot.join('\n')
}

fn stuff(layout []string) (bool, int) {
	mut ret := 0
	mut mirror := false
	mut a, mut b := 0, 1
	for ; b < layout.len; a++, b++ {
		if layout[a] == layout[b] {
			ret = b
			break
		}
	}
	mut pat_len := 0
	for ; a >= 0 && b < layout.len && layout[a] == layout[b]; a--, b++ {
		pat_len++
	}
	if a == -1 || b == layout.len {
		mirror = true
	}
	return mirror, ret
}

fn (p Pattern) calc() int {
	m, mut ret_y := stuff(p.layout)
	m2, mut ret_x := stuff(p.layout_rot)

	if m {
		return ret_y * 100
	} else if m2 {
		return ret_x
	} else {
		println('Shouldn\'t happen')
		println(p)
		return 0
	}
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut buffer := []string{}
	mut patterns := []Pattern{}
	for i, line in lines {
		if line != '' {
			buffer << line
		}
		if line == '' || i+1 == lines.len {
			patterns << Pattern.new(buffer)
			buffer = []string{}
		}
	}
	mut res := 0
	for pattern in patterns {
		res += pattern.calc()
	}
	println(res)
}
