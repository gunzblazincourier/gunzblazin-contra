# NOTE: Incomplete due to pending implementation of Flamegun's bullet spring-like trajectory

extends Area2D

const BULLET_SPEED: int = 2
var i: int = 180

func _physics_process(delta: float) -> void:
	position.x += 20 * BULLET_SPEED * delta
	position.y += 10 * BULLET_SPEED * delta
	
	
	
	#Engine.time_scale = 0.2
	#if i > 360:
		#i = 0
	#else:
		#i += 1
	#print(i)
	#
	##i += 2
	#position.y += 30*sin(i)
	##position.x += 30*cos(i)
	#if i > 90 and i < 360:
		#position.x += 30*cos(i)
	#else:
		#position.x += 60*cos(i)
