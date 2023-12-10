import os
import math

struct Card {
mut:
	id int
	draws []int
	guesses []int
}

fn Card.new(line string) Card {
	mut c := Card{}
	card_split := line.split(':')
	c.id = card_split[0][4..].trim(' ').int()

	number_split := card_split[1].split('|')
	num_draws := number_split[0].trim(' ').split(' ')
	num_guesses := number_split[1].trim(' ').split(' ')

	c.draws = num_draws.map(it.int()).filter(it != 0)
	c.guesses = num_guesses.map(it.int()).filter(it != 0)
	return c
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut cards := []Card{}
	for line in lines {
		cards << Card.new(line)
	}

	mut res := 0
	for card in cards {
		mut count := 0
		for num in card.guesses {
			if num in card.draws {
				count++
			}
		}
		if count == 0 { continue }
		res += int(math.pow(2, count-1))
	}
	println(res)
}
