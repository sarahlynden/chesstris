extends Object

class_name PawnFormationFactory

# Formation Templates
const EMPTY = []
const SINGLE = [[1]]
const H_PAIR = [[1,1]]
const D_PAIR1 = [[1,0],[0,1]]
const D_PAIR2 = [[0,1],[1,0]]
const V = [[1,0,1],[0,1,0]]
const EYES = [[1,0,0,0,0,1]]
const INVERT_V = [[0,1,0],[1,0,1]]
const UHOH = [[0,1,0,1,0,1],[1,0,1,0,1,0]]

const ALL_BAG = [SINGLE,H_PAIR,D_PAIR1,D_PAIR2,V,EYES,INVERT_V,UHOH]

const LEVEL = {
	0: {
		'bag': [SINGLE],
		'time_between_new': 2
	},
	1: {
		'bag': [H_PAIR],#[SINGLE, H_PAIR, D_PAIR1, D_PAIR2, EYES],
		'time_between_new': 3
	},
	2: {
		'bag': [V, INVERT_V],
		'time_between_new': 5
	},
	3: {
		'bag': [UHOH],
		'time_between_new': 7
	}
}

var spawn_row   # pieces always spawn at this row or above (never below)
var row_width

func _init(spawn_row_ : int, row_width_ : int) -> void:
	self.spawn_row = spawn_row_
	self.row_width = row_width_

func generate(level: int, turn: int) -> Array:
	var lvl = LEVEL[level % LEVEL.size()]
	if turn % lvl.time_between_new == 0:
		return _prep_formation(lvl.bag[randi() %  lvl.bag.size()])
	return []
	
func _prep_formation(template: Array) -> Array:
	var positions = []
	if template.size() == 0:
		return positions
	var width = template[0].size()
	var height = template.size()
	var max_x_offset = max(0, row_width - width)
	var x_offset = randi() % (max_x_offset + 1)
	for y in range(0, height):
		for x in range(0, width): 
			if template[y][x] == 1:
				positions.push_back(
					IntVec2.new(x_offset + x, spawn_row + height - y)
				)
	return positions

