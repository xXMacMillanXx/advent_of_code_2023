import os

struct MyChecker {
mut:
	top_left int = -1
	top_middle int = -1
	top_right int = -1
	middle_left int = -1
	middle_right int = -1
	bottom_left int = -1
	bottom_middle int = -1
	bottom_right int = -1
}

fn (c MyChecker) get_result() []int {
	mut ret := []int{}
	if c.top_middle != -1 {
		ret << c.top_middle
	} else if c.top_left != -1 || c.top_right != -1 {
		if c.top_left != -1 { ret << c.top_left }
		if c.top_right != c.top_left && c.top_right != -1 {
			ret << c.top_right
		}
	}
	if c.middle_left != -1 { ret << c.middle_left }
	if c.middle_right != -1 { ret << c.middle_right }
	if c.bottom_middle != -1 {
		ret << c.bottom_middle
	} else if c.bottom_left != -1 || c.bottom_right != -1 {
		if c.bottom_left != -1 { ret << c.bottom_left }
		if c.bottom_right != c.bottom_left && c.bottom_right != -1 {
			ret << c.bottom_right
		}
	}
	return ret
}

fn get_num_at(input string, index int) int {
	mut left_i := index
	mut right_i := index
	for left_i > 0 && input[left_i].is_digit() {
		if input[left_i-1].is_digit() { left_i-- } else { break }
	}
	for right_i < input.len && input[right_i].is_digit() {
		right_i++
	}
	return input[left_i..right_i].int()
}

fn check_surroundings(input []string, index int) []int {
	mut ret := MyChecker{}
	if index > 0 {
		if input[0][index-1].is_digit() { ret.top_left = get_num_at(input[0], index-1) }
		if input[1][index-1].is_digit() { ret.middle_left = get_num_at(input[1], index-1) }
		if input[2][index-1].is_digit() { ret.bottom_left = get_num_at(input[2], index-1) }
	}
	if input[0][index].is_digit() { ret.top_middle = get_num_at(input[0], index) }
	if input[2][index].is_digit() { ret.bottom_middle = get_num_at(input[2], index) }

	if input[0][index+1].is_digit() { ret.top_right = get_num_at(input[0], index+1) }
	if input[1][index+1].is_digit() { ret.middle_right = get_num_at(input[1], index+1) }
	if input[2][index+1].is_digit() { ret.bottom_right = get_num_at(input[2], index+1) }

	return ret.get_result()
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut res := 0
	for li := 1; li < lines.len-1; li++ {
		line := lines[li]
		for i, c in line {
			if c != `*` { continue }
			part_nums := check_surroundings([lines[li-1], lines[li], lines[li+1]], i)
			if part_nums.len == 2 {
				res += part_nums[0] * part_nums[1]
			}
		}
	}
	println(res)
}
