extends Area2D
class_name Drop


enum DropType {
	HP = 0
}

const GROUP = 'drop'

export (DropType) var type = DropType.HP

onready var animation = $AnimationPlayer


func _ready():
	add_to_group(GROUP)
	if animation.has_animation("bop"):
		animation.play("bop")
