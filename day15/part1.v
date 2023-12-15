import os

fn hash(s string) int {
	mut ret := 0
	for c in s {
		ret += c
		ret *= 17
		ret %= 256
	}
	return ret
}

fn main() {
	line := os.read_file('input.txt')!
	inputs := line.split(',')
	mut res := 0
	for input in inputs {
		res += hash(input)
	}
	println(res)
}
