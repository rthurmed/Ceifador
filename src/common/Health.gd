extends Node2D
class_name Health


signal dead
signal damage
signal updated

export var max_hp = 10
export var color = Color('e14141')
export var immortal = false

onready var bar = $Bar

var hp = 1
var alive = true


func _ready():
	hp = max_hp
	bar.value = max_hp
	bar.max_value = max_hp
	bar.modulate = color


func transact(amount):
	hp += amount
	hp = clamp(hp, 0, max_hp)
	bar.max_value = max_hp
	bar.value = hp
	emit_signal("updated")


func hit(amount = -1):
	if not alive: return
	
	transact(amount)
	
	emit_signal("damage")
	
	if not immortal and alive and hp <= 0:
		emit_signal("dead")
		alive = false


func heal(amount = 1):
	transact(amount)


func get_value():
	return hp
