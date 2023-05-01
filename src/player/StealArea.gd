extends Area2D


signal stole_energy

const COLOR_EMPTY = Color('3fffffff')
const COLOR_GRABBED = Color('3f6eeeff')

onready var timer: Timer = $Timer
onready var sprite = $Sprite
onready var progress = $Progress

var target = null


func _ready():
	sprite.modulate = COLOR_EMPTY


func _process(_delta):
	# TODO: draw line to target
	progress.value = Util.timer_percent(timer) * 100
	pass


func _on_StealArea_area_entered(area):
	if target != null: return
	target = area
	timer.start()
	# sprite.modulate = COLOR_GRABBED


func _on_StealArea_area_exited(area: Area2D):
	if target == null: return
	if area.get_path() != target.get_path(): return
	
	timer.stop()
	
	target = null
	# sprite.modulate = COLOR_EMPTY


func _on_Timer_timeout():
	if target == null: return
	emit_signal("stole_energy")
