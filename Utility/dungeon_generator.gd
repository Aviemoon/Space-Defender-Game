extends Node2D

@export var dimensions:Vector2i = Vector2i(5, 5)
@export var entrance:Vector2i = Vector2i(3, 0)
@export var shortest_path:int = 15
var dungeon:Array

func _ready():
	init_dungeon()
	place_entrance()
	generate_crit_path(entrance, shortest_path)
	print_dungeon()

func init_dungeon():
	for x in dimensions.x: # rows of rooms
		dungeon.append([])
		for y in dimensions.y: # columns of rooms
			dungeon[x].append(0)

func generate_crit_path(start, length):
	
	if length == 0:
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
		if current.x + direction.x >= 0 and current.x + direction.x < dimensions.x and current.y + direction.y >= 0 and current.y + direction.y < dimensions.y and not dungeon[current.x + direction.x][current.y + direction.y]:
			current += direction
			dungeon[current.x][current.y] = length
			print(current)
			print(direction)
			if generate_crit_path(current, length - 1):
				print_dungeon()
				print(current)
				print(direction)
				return true
			else:
				dungeon[current.x][current.y] = 0
				current -= direction
			direction = Vector2i(direction.y, -direction.x)
			print_dungeon()
			
	return false
	
func place_entrance():
	# --- making sure its all in bounds
	if entrance.x < 0 or entrance.x >= dimensions.x:
		entrance.x = randi_range(0, dimensions.x - 1)
	if entrance.y < 0 or entrance.y >= dimensions.y:
		entrance.y = randi_range(0, dimensions.y - 1)
	
	dungeon[entrance.x][entrance.y] = 'S'



func print_dungeon():
	var dng_str:String = ''
	for y in range(dimensions.y - 1, -1 ,-1):
		for x in dimensions.x:
			dng_str += '[%s]' % str(dungeon[x][y])
		dng_str += '\n'
	print(dng_str)
