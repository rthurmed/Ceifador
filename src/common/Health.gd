extends Node2D
class_name Health


signal dead
signal damage

export var max_hp = 10

onready var bar = $Bar

var hp = 1
var alive = true


func _ready():
	hp = max_hp
	bar.value = max_hp
	bar.max_value = max_hp


func hit(amount = -1):
	if not alive: return
	
	hp += amount
	hp = clamp(hp, 0, max_hp)
	
	emit_signal("damage")
	
	if alive and hp <= 0:
		emit_signal("dead")
		alive = false
	
	bar.max_value = max_hp
	bar.value = hp
