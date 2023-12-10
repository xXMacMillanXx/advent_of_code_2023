import os
import arrays

const number_names := ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

fn check_number_word(splice string) int {
	for i, val in number_names {
		if splice.index(val) or {1} == 0 {
			return i
		}
	}
	return -1
}

fn number_lexer(line string) []int {
	mut ret := []int {}
	mut index := 0
	for index < line.len {
		mut res := -1
		match line[index] {
			`0` ... `9` { res = line[index].ascii_str().int() }
			`e`, `f`, `n`, `o`, `s`, `t` {
				res = check_number_word(line[index..])
			}
			else { res = -1 }
		}
		if res != -1 {
			ret << res
		}
		index++
	}
	return ret
}

fn get_all_nums(lines []string) []int {
	mut ret := []int{}
	for line in lines {
		nums := number_lexer(line)
		ret << nums[0] * 10 + nums[nums.len - 1]
	}
	return ret
}

fn main() {
	lines := os.read_lines("input.txt")!
	nums := get_all_nums(lines)
	println(arrays.sum(nums) or { 0 })
}
