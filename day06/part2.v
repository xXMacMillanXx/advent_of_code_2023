import os
import regex

struct Race {
	time i64
	distance i64
}

fn Race.new(t i64, d i64) Race {
	return Race {t, d}
}

fn (r Race) get_winner_amount() i64 {
	mut first := i64(0)
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
	time := re.find_all_str(lines[0]).join('').i64()
	distance := re.find_all_str(lines[1]).join('').i64()

	race := Race.new(time, distance)
	println(race.get_winner_amount())
}
