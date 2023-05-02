extends Node2D
class_name Stage


const GROUP = 'stage'
const Player = preload("res://src/player/Player.tscn")


func _ready():
	add_to_group(GROUP)
	
	if len(get_tree().get_nodes_in_group('player')) == 0:
		# spawns a test player
		var instance = Player.instance()
		instance.global_position = Vector2(112, 230)
		add_child(instance)
