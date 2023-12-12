import os

struct Spring {
	row string
	parts []string
	fails []int
}

fn Spring.new(line string) Spring {
	sp := line.split(' ')
	return Spring { sp[0], sp[0].split('.').filter(it != ''), sp[1].split(',').map(it.int()) }
}

fn (s Spring) arrangements() int {
	// group possible parts and fails together
	// change position if possible and count++
	// if first pattern happens again, return count
	return -1
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut springs := []Spring{}
	for line in lines {
		springs << Spring.new(line)
	}
	println(springs[0])
}
