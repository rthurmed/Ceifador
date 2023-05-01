extends ParallaxBackground


export var speed = 20.0 # per second


func _process(delta):
	scroll_offset.y += speed * delta
