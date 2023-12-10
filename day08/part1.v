import os

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

fn main() {
	lines := os.read_lines('input.txt')!
	instructions := lines[0]

	mut nodes := map[string]Node{}
	for line in lines[2..] {
		nodes[line.substr(0, 3)] = Node.new(line)
	}

	mut next := 'AAA'
	mut res := 0
	for i := 0; i < instructions.len; i++ {
		if nodes[next].name == 'ZZZ' { break }
		next = nodes[next].follow(instructions[i])
		res++
		if i+1 == instructions.len { i = -1 }
	}
	println(res)
}
