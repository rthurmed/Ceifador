extends Area2D


signal stole_energy

const COLOR_EMPTY = Color('3fffffff')
const COLOR_GRABBED = Color('3f6eeeff')

onready var timer: Timer = $Timer
onready var progress = $Progress
onready var line = $Line

var target = null


func _process(_delta):
	# update line
	var has_target = target != null
	line.visible = has_target
	
	if has_target:
		line.points[1] = to_local(target.global_position)
	
	# update radial progress
	progress.value = Util.timer_percent(timer) * 100


func _on_StealArea_area_entered(area):
	if target != null: return
	target = area
	timer.start()


func _on_StealArea_area_exited(area: Area2D):
	if target == null: return
	if area.get_path() != target.get_path(): return
	
	timer.stop()
	
	target = null


func _on_Timer_timeout():
	if target == null: return
	emit_signal("stole_energy")
