extends Area2D
## Weak point of the defense wall, destroy it to beat the level1 boss
##
## Responsible for animation and hitbox

## Health
var health: int

## Animation player
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 6


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if health >= 0:
			health -= 1
		else:
			animation_player.play("explode")
			set_deferred("monitorable", false)
			set_deferred("monitoring", false)
			Global.is_boss_felled = true
			#animated_sprite_2d.play("explode")
			#death_explosion_sfx.play()
			#Global.score += 300
	#print(health)
	#print(Global.is_boss_felled)
