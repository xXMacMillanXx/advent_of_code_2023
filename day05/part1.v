import os
import arrays

struct Rule {
mut:
	source i64
	destination i64
	range i64
	offset i64
}

fn Rule.new(input string) Rule {
	mut ret := Rule{}
	vals := input.split(' ').map(it.i64())
	ret.destination = vals[0]
	ret.source = vals[1]
	ret.range = vals[2]
	ret.offset = vals[0] - vals[1]
	return ret
}

struct Block {
mut:
	name string
	rules []Rule
}

fn Block.new(input []string) Block {
	mut ret := Block{}
	ret.name = input[0]
	for x := 1; x < input.len; x++ {
		ret.rules << Rule.new(input[x])
	}
	return ret
}

fn map_block(seed i64, block Block) i64 {
	for rule in block.rules {
		if seed >= rule.source && seed < rule.source + rule.range {
			return seed + rule.offset
		}
	}

	return seed
}

fn main() {
	lines := os.read_lines('input.txt')!
	seeds := lines[0][7..].split(' ').map(it.i64())
	mut blocks := []Block{}

	for i := 2; i < lines.len; i++ {
		mut block_start := i
		for lines[i] != '' {
			i++
			if i == lines.len {
				break
			}
		}
		blocks << Block.new(lines[block_start..i])
	}

	mut res := []i64{}
	for seed in seeds {
		mut sub := seed
		for block in blocks {
			sub = map_block(sub, block)
		}
		res << sub
	}
	println(arrays.min(res) or {0})
}
