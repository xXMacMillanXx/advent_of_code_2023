import os

struct Data {
mut:
	nums []int
}

fn Data.new(s string) Data {
	return Data { s.split(' ').map(it.int()) }
}

fn (d Data) compute() int {
	mut steps := [][]int{}
	mut idx := 0
	steps << d.nums
	for !is_all_zero(steps[idx]) {
		steps << []int{}
		for n1, n2 := 0, 1; n2 < steps[idx].len; n1++, n2++ {
			steps[idx+1] << steps[idx][n2] - steps[idx][n1]
		}
		// println("${idx} ${steps[idx]}")
		idx++
	}
	// println("${idx} ${steps[idx]}")

	steps[idx] << 0
	for ; idx > 0; idx-- {
		steps[idx-1].insert(0, steps[idx-1].first() - steps[idx].first())
		// println("${idx-1} ${steps[idx-1]}")
	}
	return steps[idx].first()
}

fn is_all_zero(i []int) bool {
	for num in i {
		if num != 0 {
			return false
		}
	}
	return true
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut data := []Data{}
	for line in lines {
		data << Data.new(line)
	}
	mut res := 0
	for d in data {
		res += d.compute()
	}
	println(res)
}
