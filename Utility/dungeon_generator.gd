extends Node2D

@export var dimensions:Vector2i = Vector2i(5, 5)
@export var start_pos:Vector2i = Vector2i(3, 0)
@export var shortest_path:int = 10
@export var branches:int = 3
@export var branch_length:Vector2i = Vector2i(1, 3)
var usable_branch:Array[Vector2i]
var dungeon:Array

func _ready():
	init_dungeon()
	place_entrance()
	generate_crit_path(start_pos, shortest_path)
	generate_branches()
	print_dungeon()

func init_dungeon():
	for x in dimensions.x: # rows of rooms
		dungeon.append([])
		for y in dimensions.y: # columns of rooms
			dungeon[x].append(0)

func generate_crit_path(start:Vector2i, length:int, marker:String = ''):
	if length <= 0:
		return true
	
	var current:Vector2i = start
	var direction:Vector2i
	
	match randi_range(0, 3): # direction of the path
		0:
			direction = Vector2.UP
		1:
			direction = Vector2.RIGHT
		2:
			direction = Vector2.DOWN
		3:
			direction = Vector2.LEFT
	
	# --- check if direction in bounds ---
	for i in range(4):
		if (current.x + direction.x >= 0) and (current.x + direction.x < dimensions.x) and (current.y + direction.y >= 0) and (current.y + direction.y < dimensions.y) and not (dungeon[current.x + direction.x][current.y + direction.y]):
			current += direction
			
			if not marker:
				dungeon[current.x][current.y] = length
			else:
				dungeon[current.x][current.y] = marker
			if length > 1:
				usable_branch.append(current)
			if generate_crit_path(current, length - 1, marker):
				return true
			else:
				usable_branch.erase(current)
				dungeon[current.x][current.y] = 0
				current -= direction
		direction = Vector2i(direction.y, -direction.x)
	return false
	
func place_entrance():
	# --- making sure its all in bounds
	if start_pos.x < 0 or start_pos.x >= dimensions.x:
		start_pos.x = randi_range(0, dimensions.x - 1)
	if start_pos.y < 0 or start_pos.y >= dimensions.y:
		start_pos.y = randi_range(0, dimensions.y - 1)
	
	dungeon[start_pos.x][start_pos.y] = 'S'

func print_dungeon():
	var dng_str:String = ''
	for y in range(dimensions.y - 1, -1 ,-1):
		for x in dimensions.x:
			if dungeon[x][y]:
				dng_str += '[%s]' % str(dungeon[x][y])
			else:
				dng_str += '   '
		dng_str += '\n'
	print(dng_str)

func generate_branches():
	var branches_created:int = 0
	var candidate:Vector2i 
	while branches_created < branches and usable_branch.size():
		candidate = usable_branch[randi_range(0, usable_branch.size() - 1)]
		if generate_crit_path(candidate, randi_range(branch_length.x, branch_length.y), 'B'):
			branches_created += 1
		else:
			usable_branch.erase(candidate)
