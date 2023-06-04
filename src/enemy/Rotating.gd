extends Node2D


export var movement_deg = 30 # degrees each time
export (float, 0.001, 2) var time_slot: float = 0.5
export (float, 0.0, 2) var time_delay: float = 0.0

onready var timer = $Timer

var delay_passed = false


func _ready():
	timer.wait_time = time_slot
	timer.start(time_delay)


func _on_Timer_timeout():
	if not delay_passed:
		timer.wait_time = time_slot
		delay_passed = true
	
	rotate(movement_deg)
	
