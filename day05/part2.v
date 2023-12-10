import os
import arrays
import sync.pool

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

pub struct Work {
	seed i64
	range i64
	blocks []Block
}

fn Work.new(s i64, r i64, b []Block) Work {
	return Work { s, r, b }
}

fn map_block(seed i64, block Block) i64 {
	for rule in block.rules {
		if seed >= rule.source && seed < rule.source + rule.range {
			return seed + rule.offset
		}
	}

	return seed
}

fn multi_mapping(mut pp pool.PoolProcessor, idx int, wid int) &i64 {
	println('Working on main seed ${pp.get_item[Work](idx).seed}')
	mut sub_res := []i64{}
	for seed := pp.get_item[Work](idx).seed; seed < pp.get_item[Work](idx).seed + pp.get_item[Work](idx).range; seed++ {
		mut sub := seed
		for block in pp.get_item[Work](idx).blocks {
			sub = map_block(sub, block)
		}
		sub_res << sub
	}
	println('Finished main seed ${pp.get_item[Work](idx).seed}')
	ret := arrays.min(sub_res) or {0}
	return &ret
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
	mut pp := pool.new_pool_processor(maxjobs: 3, callback: multi_mapping)
	mut work := []Work{}
	for i := 0; i < seeds.len; i = i + 2 {
		work << Work.new(seeds[i], seeds[i+1], blocks)
	}
	pp.work_on_items(work)
	for x in pp.get_results[i64]() {
		res << x
	}
	println(arrays.min(res) or {0})
}
