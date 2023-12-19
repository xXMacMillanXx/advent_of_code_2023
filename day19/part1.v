import os

struct Condition {
	var string
	operation rune
	check int
	if_true string
}

fn Condition.new(s string) Condition {
	if !s.contains(':') {
		return Condition{ '', ` `, -1, s }
	}
	sp := s.split(':')
	mut sp_con := []string{}
	mut op := ` `
	if s.contains('<') {
		sp_con = sp[0].split('<')
		op = `<`
	} else {
		sp_con = sp[0].split('>')
		op = `>`
	}
	return Condition{ sp_con[0], op, sp_con[1].int(), sp[1] }
}

fn (c Condition) evaluate(p Part) ?string {
	match c.operation {
		`>` {
			if p.get_value_of(c.var) or {0} > c.check {
				return c.if_true
			}
		}
		`<` {
			if p.get_value_of(c.var) or {0} < c.check {
				return c.if_true
			}
		}
		else { return c.if_true }
	}
	return none
}

struct Workflow {
	name string
	conditions []Condition
}

fn Workflow.new(s string) Workflow {
	n := s.before('{')
	mut c := []Condition{}
	for con in s[n.len+1..s.len-1].split(',') {
		c << Condition.new(con)
	}
	return Workflow{ n, c }
}

struct Part {
	x int
	m int
	a int
	s int
}

fn Part.new(s string) Part {
	sp := s[1..s.len-1].split(',').map(it.split('='))
	mut temp := map[string]int{}
	for pair in sp {
		temp[pair[0]] = pair[1].int()
	}
	return Part { temp['x'], temp['m'], temp['a'], temp['s'] }
}

fn (p Part) get_value_of(s string) ?int {
	return match s {
		'x' { p.x }
		'm' { p.m }
		'a' { p.a }
		's' { p.s }
		else { none }
	}
}

fn (p Part) sum() int {
	return p.x + p.m + p.a + p.s
}

fn main() {
	lines := os.read_lines('input.txt')!
	mut i := 0

	mut workflows := map[string]Workflow{}
	for ; lines[i] != '' ; i++ {
		w := Workflow.new(lines[i])
		workflows[w.name] = w
	}
	i++
	mut parts := []Part{}
	for ; i < lines.len; i++ {
		parts << Part.new(lines[i])
	}

	mut res := 0
	next_part: for part in parts {
		mut wf := 'in'
		mut idx := 0
		for ; idx < workflows[wf].conditions.len; idx++ {
			cond := workflows[wf].conditions[idx]
			s := cond.evaluate(part) or { continue }
			match s {
				'A' {
					res += part.sum()
					continue next_part
				}
				'R' { continue next_part }
				else {
					wf = s
					idx = -1
				}
			}
		}
	}
	println(res)
}
