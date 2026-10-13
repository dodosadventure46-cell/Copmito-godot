extends CharacterBody2D

signal enemy_died(name)

@export var speed: float = 80.0
@export var max_hp: int = 80
@export var is_boss: bool = false

var hp: int
var patrol_dir: int = 1
var patrol_min_x: float = 0.0
var patrol_max_x: float = 0.0

func _ready() -> void:
    hp = max_hp
    add_to_group("enemies")
    patrol_min_x = global_position.x - 120
    patrol_max_x = global_position.x + 120

    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/enemy.svg") if not is_boss else load("res://assets/boss.svg")
    sprite.position = Vector2(-16, -16) if not is_boss else Vector2(-24, -24)
    add_child(sprite)

func _physics_process(delta: float) -> void:
    var player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
    if is_boss and player:
        var dir = (player.global_position - global_position).normalized()
        velocity = dir * (speed * 1.1)
    else:
        if global_position.x < patrol_min_x:
            patrol_dir = 1
        elif global_position.x > patrol_max_x:
            patrol_dir = -1
        velocity.x = patrol_dir * speed
        velocity.y = 0

    move_and_slide()

func take_damage(amount: int, source: String = "") -> void:
    hp -= amount
    if hp <= 0:
        die()

func die() -> void:
    emit_signal("enemy_died", name)
    queue_free()
