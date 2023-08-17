extends Node3D 
 
var all_points = {}
var asmap = null
@onready var gridmap = $GridMap

func _ready():
	asmap = AStar3D.new()
	var cells = gridmap.get_used_cells()
	for cell in cells:
		var ind = asmap.get_available_point_id()
		asmap.add_point(ind, gridmap.map_to_local(Vector3(cell.x, cell.y, cell.z)))
		all_points[v3_to_index(cell)] = ind
	for cell in cells:
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				for z in [-1, 0, 1]:
					var v3 = Vector3(x, y, z)
					if v3 == Vector3(0, 0, 0):
						continue
					if v3_to_index(v3 + Vector3(cell.x, cell.y, cell.z)) in all_points:
						var ind1 = all_points[v3_to_index(cell)]
						var ind2 = all_points[v3_to_index(Vector3(cell.x, cell.y, cell.z) + v3)]
						if !asmap.are_points_connected(ind1, ind2):
							asmap.connect_points(ind1, ind2, true)
 
func v3_to_index(v3):
	return str(int(round(v3.x))) + "," + str(int(round(v3.y))) + "," + str(int(round(v3.z)))
 
func get_paths(start, end):
	var gm_start = v3_to_index(gridmap.local_to_map(start))
	var gm_end = v3_to_index(gridmap.local_to_map(end))
	var start_id = 0
	var end_id = 0
	if gm_start in all_points:
		start_id = all_points[gm_start]
	else:
		start_id = asmap.get_closest_point(start)
 
	if gm_end in all_points:
		end_id = all_points[gm_end]
	else:
		end_id = asmap.get_closest_point(end)
 
	return asmap.get_point_path(start_id, end_id)
