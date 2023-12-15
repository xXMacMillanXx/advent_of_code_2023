import os

struct Box {
mut:
	lens []Lens
}

fn Box.new() Box {
	return Box{}
}

fn (b Box) contains(l Lens) bool {
	for lens in b.lens {
		if l.label == lens.label {
			return true
		}
	}
	return false
}

fn (b Box) index_of(l Lens) int {
	for i, lens in b.lens {
		if l.label == lens.label {
			return i
		}
	}
	return -1
}

fn (mut b Box) add(l Lens) {
	b.lens << l
}

fn (mut b Box) replace(l Lens) {
	idx := b.index_of(l)
	b.lens[idx].focal_length = l.focal_length
}

fn (mut b Box) remove(l Lens) {
	if b.contains(l) {
		idx := b.index_of(l)
		b.lens.delete(idx)
	}
}

struct Lens {
	mut: focal_length int
	label string
	hash int
}

fn Lens.new(fl int, label string) Lens {
	return Lens { fl, label, hash(label) }
}

// only used for delete instruction
fn Lens.inst(label string) Lens {
	return Lens{ -1, label, hash(label) }
}

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
	instructions := line.split(',')

	mut hashmap := []Box { len: 256, init: Box.new() }
	for instruction in instructions {
		if instruction.contains('-') {
			lens := Lens.inst(instruction[..instruction.len-1])
			hashmap[lens.hash].remove(lens)
		} else {
			sp := instruction.split('=')
			lens := Lens.new(sp[1].int(), sp[0])
			if hashmap[lens.hash].contains(lens) {
				hashmap[lens.hash].replace(lens)
			} else {
				hashmap[lens.hash].add(lens)
			}
		}
	}

	mut res := 0
	for i, box in hashmap {
		for j, lens in box.lens {
			res += (1 + i) * (j+1) * lens.focal_length
		}
	}
	println(res)
}
