import os
import math

struct Node {
mut:
	name string
	left string
	right string
}

fn Node.new(data string) Node {
	return Node{ data.substr(0, 3), data.substr(7, 10), data.substr(12, 15) }
}

fn (n Node) follow(inst rune) string {
	return match inst {
		`L` { n.left }
		`R` { n.right }
		else { n.left }
	}
}

fn lowest_common_multiple(nums []int) i64 {
	mut ret := i64(nums[0])
	for num in nums[1..] {
		ret = math.lcm(ret, num)
	}
	return ret
}

fn main() {
	lines := os.read_lines('input.txt')!
	instructions := lines[0]

	mut nodes := map[string]Node{}
	mut starts := []string{}
	for line in lines[2..] {
		n := line.substr(0, 3)
		nodes[n] = Node.new(line)
		if n[2] == `A` {
			starts << n
		}
	}

	mut results := []int{}
	for start in starts {
		mut next := start
		mut steps := 0
		for i := 0; i < instructions.len; i++ {
			if nodes[next].name[2] == `Z` { break }
			next = nodes[next].follow(instructions[i])
			steps++
			if i+1 == instructions.len { i = -1 }
		}
		results << steps
	}
	println(lowest_common_multiple(results))
}
