extends Node


export var target_path: NodePath
export var blink = false
export var blink_time: float = 0.1

onready var target: Node2D = get_node(target_path)

var time = 0.0


func _process(delta):
	if not blink: return
	time += delta
	target.visible = int(floor(time / blink_time)) % 2 == 0


func set_target_visible(value: bool):
	target.visible = value


func show():
	target.visible = true
