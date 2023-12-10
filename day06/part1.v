import os
import regex

struct Race {
	time int
	distance int
}

fn Race.new(t int, d int) Race {
	return Race {t, d}
}

fn (r Race) get_winner_amount() int {
	mut first := 0
	for ; first < r.time; first++ {
		diff := r.time - first
		if first * diff > r.distance {
			break
		}
	}
	return r.time - first * 2 + 1
}

fn main() {
	lines := os.read_lines('input.txt')!

	mut re := regex.regex_opt('\\d+')!
	times := re.find_all_str(lines[0]).map(it.int())
	distances := re.find_all_str(lines[1]).map(it.int())

	mut races := []Race{}
	for i := 0; i < times.len; i++ {
		races << Race.new(times[i], distances[i])
	}
	
	mut res := 1
	for race in races {
		res *= race.get_winner_amount()
	}
	println(res)
}
