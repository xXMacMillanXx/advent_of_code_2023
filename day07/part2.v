import os

enum Value {
	ace king queen ten nine eight
	seven six five four three two joker
}

fn Value.from_rune(s rune) Value {
	return match s {
		`J` { Value.joker }
		`2` { Value.two }
		`3` { Value.three }
		`4` { Value.four }
		`5` { Value.five }
		`6` { Value.six }
		`7` { Value.seven }
		`8` { Value.eight }
		`9` { Value.nine }
		`T` { Value.ten }
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

fn Combo.analyze(nums []int, jokers int) Combo {
	sn := nums.sorted(a > b)
	mut pre_ret := Combo.high_card
	if sn[0] == 5 { pre_ret = Combo.five_kind }
	if sn[0] == 4 { pre_ret = Combo.four_kind }
	if sn[0] == 3 && sn[1] == 2 { pre_ret = Combo.full_house }
	else if sn[0] == 3 { pre_ret = Combo.three_kind }
	if sn[0] == 2 && sn[1] == 2 { pre_ret = Combo.two_pair }
	else if sn[0] == 2 { pre_ret = Combo.one_pair }
	if jokers == 0 { return pre_ret }

	mut ret := pre_ret
	match pre_ret {
		.five_kind {}
		.four_kind { if jokers == 1 { ret = .five_kind } }
		.full_house {}
		.three_kind {
			match jokers {
				1 { ret = .four_kind }
				2 { ret = .five_kind }
				else {}
			}
		}
		.two_pair { if jokers == 1 { ret = .full_house } }
		.one_pair {
			match jokers {
				1 { ret = .three_kind }
				2 { ret = .four_kind }
				3 { ret = .five_kind }
				else {}
			}
		}
		.high_card {
			match jokers {
				1 { ret = .one_pair }
				2 { ret = .three_kind }
				3 { ret = .four_kind }
				4 { ret = .five_kind }
				5 { ret = .five_kind }
				else {}
			}
		}
	}
	return ret
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
	mut jokers := 0
	for key, val in groups {
		if key == .joker {
			jokers = val
			continue
		}
		counted << val
	}
	for counted.len < 2 { counted << 0 }
	ret.combo = Combo.analyze(counted, jokers)
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
