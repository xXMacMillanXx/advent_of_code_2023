import os

enum Value {
	ace king queen jack ten nine eight
	seven six five four three two
}

fn Value.from_rune(s rune) Value {
	return match s {
		`2` { Value.two }
		`3` { Value.three }
		`4` { Value.four }
		`5` { Value.five }
		`6` { Value.six }
		`7` { Value.seven }
		`8` { Value.eight }
		`9` { Value.nine }
		`T` { Value.ten }
		`J` { Value.jack }
		`Q` { Value.queen }
		`K` { Value.king }
		`A` { Value.ace }
		else { Value.two }
	}
}

fn (v Value) get_int() int {
	return int(v)
}

enum Combo {
	five_kind four_kind full_house
	three_kind two_pair one_pair high_card
}

fn Combo.analyze(nums []int) Combo {
	sn := nums.sorted(a > b)
	if sn[0] == 5 { return Combo.five_kind }
	if sn[0] == 4 { return Combo.four_kind }
	if sn[0] == 3 && sn[1] == 2 { return Combo.full_house }
	if sn[0] == 3 { return Combo.three_kind }
	if sn[0] == 2 && sn[1] == 2 { return Combo.two_pair }
	if sn[0] == 2 { return Combo.one_pair }
	return Combo.high_card
}

fn (c Combo) get_int() int {
	return int(c)
}

struct Hand {
mut:
	cards []Value
	combo Combo
	bet int
}

fn Hand.new(s string) Hand {
	data := s.split(' ')
	mut ret := Hand{}
	mut groups := map[Value]int{}
	mut counted := []int{}
	for c in data[0] {
		v := Value.from_rune(c)
		ret.cards << v
		groups[v] += 1
	}
	for _, val in groups {
		counted << val
	}
	ret.combo = Combo.analyze(counted)
	ret.bet = data[1].int()
	return ret
}

fn hand_compare(a &Hand, b &Hand) int {
	if a.combo.get_int() < b.combo.get_int() {
		return -1
	} else if a.combo.get_int() > b.combo.get_int() {
		return 1
	}

	for i := 0; i < a.cards.len; i++ {
		if a.cards[i].get_int() < b.cards[i].get_int() {
			return -1
		} else if a.cards[i].get_int() > b.cards[i].get_int() {
			return 1
		}
	}
	return 0
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut hands := []Hand{}
	for line in lines {
		hands << Hand.new(line)
	}
	hands.sort_with_compare(hand_compare)

	mut res := 0
	mut multip := hands.len
	for hand in hands {
		res += hand.bet * multip
		multip--
	}
	println(res)
}
