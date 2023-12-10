import os
import arrays

fn get_simple_nums(lines []string) []int {
	mut ret := []int{}
	for line in lines {
		mut num := 0
		for c in line {
			if c.is_digit() { 
				num = c.ascii_str().int() * 10
				break
			}
		}
		for c := line.len - 1; c >= 0; c-- {
			if line[c].is_digit() { 
				num += line[c].ascii_str().int()
				break
			}
		}
		ret << num
	}
	return ret
}

fn main() {
	lines := os.read_lines("input.txt")!
	nums := get_simple_nums(lines)
	println(arrays.sum(nums) or { 0 })
}
