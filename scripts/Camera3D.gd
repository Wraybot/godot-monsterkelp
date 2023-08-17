extends Camera3D
 

@onready var target = get_parent().get_node("target")
 
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		get_tree().call_group("kelps", "move_to", target.position)
