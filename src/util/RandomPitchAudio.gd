extends AudioStreamPlayer


var rng = RandomNumberGenerator.new()


func play(from_position: float = 0.0):
	rng.randomize()
	pitch_scale = rng.randf_range(0.6, 1.4)
	.play(from_position) # calling super
