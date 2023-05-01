extends PathFollow2D


export var speed = 50 # pixels per seconds


func _process(delta):
	offset += speed * delta
