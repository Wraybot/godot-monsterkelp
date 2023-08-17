extends CharacterBody3D

var path = []
var path_ind = 0
const move_speed = 1

@onready var amap = get_parent()

@onready var feelers = get_tree().get_nodes_in_group("feelers")

var max_feeler_length = .5


var points:Array
var lines:Array
var colors = [Color8(235, 0, 41), Color8(243, 98, 0), Color8(234, 212, 0), Color8(103, 172, 11),
				Color8(0, 163, 221), Color8(132, 1, 203)]


func _ready():
	add_to_group("kelps")
	draw_debug_visuals()


func _physics_process(_delta):
	if path_ind < path.size():
		var move_vec = (path[path_ind] - feelers[-1].global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			feelers[-1].velocity = move_vec.normalized() * move_speed
			feelers[-1].move_and_slide()
			update_debug_visuals()
			
			
func move_to(target):
	path = amap.get_paths(feelers[-1].position, target)
	path_ind = 0
	

func draw_debug_visuals():
	"""Draws a simplified visual"""
	for feeler in feelers.size():
		print(1)
		var point = Draw3D.point(feelers[feeler].position, self, .1, colors[feeler])
		points.append(point)

		if feeler + 1 == feelers.size():
			break
		else:
			var line = Draw3D.line(feelers[feeler].position, feelers[feeler+1].position, self, colors[feeler])
			lines.append(line)


func update_debug_visuals():
	for l in lines:
		l.queue_free()
	lines.clear()
	
	for feeler in feelers.size():
		points[feeler].position = feelers[feeler].position
		if feeler + 1 == feelers.size():
			break
		else:
			var line = Draw3D.line(feelers[feeler].position, feelers[feeler+1].position, self, colors[feeler])
			lines.append(line)
