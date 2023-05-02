extends Node2D


export var speed_deg = 30 # degrees per seconds


func _process(delta):
	rotate(deg2rad(speed_deg * delta))
