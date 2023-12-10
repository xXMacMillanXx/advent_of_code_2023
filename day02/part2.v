import os

struct Set {
mut:
	red int
	green int
	blue int
}

fn Set.new(input string) Set {
	mut ret := Set{}
	mut cube_split := input.split(',')
	for i, cs in cube_split {
		cube_split[i] = cs.trim(' ')
	}
	for color in cube_split {
		check := color.split(' ')
		match check[1] {
			'red' { ret.red = check[0].int() }
			'green' { ret.green = check[0].int() }
			'blue' { ret.blue = check[0].int() }
			else {}
		}
	}
	return ret
}

struct Game {
mut:
	id int
	sets []Set
}

fn Game.new(line string) Game {
	mut ret := Game{}
	game_split := line.split(':')
	ret.id = game_split[0][5..].int()

	set_split := game_split[1].split(';')
	for sp in set_split {
		ret.sets << Set.new(sp)
	}
	return ret
}

fn (g Game) highest_rgb() Set {
	mut ret := Set{}
	for set in g.sets {
		if set.red > ret.red { ret.red = set.red }
		if set.green > ret.green { ret.green = set.green }
		if set.blue > ret.blue { ret.blue = set.blue }
	}
	return ret
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut games := []Game{}
	for line in lines {
		games << Game.new(line)
	}
	mut result := 0
	for game in games {
		highest := game.highest_rgb()
		result += highest.red * highest.green * highest.blue
	}
	println(result)
}