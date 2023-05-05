extends Area2D
class_name Drop


enum DropType {
	HP = 0
}

const GROUP = 'drop'

export (DropType) var type = DropType.HP


func _ready():
	add_to_group(GROUP)
