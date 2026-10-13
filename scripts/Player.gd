extends CharacterBody2D

signal hp_changed(new_hp)
signal player_died

@export var speed: float = 200.0
@export var max_hp: int = 100
var hp: int = max_hp

var attack_cooldown: float = 0.5
var attack_timer: float = 0.0

func _ready() -> void:
    add_to_group("player")
    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/player.svg")
    sprite.position = Vector2(-16, -16)
    add_child(sprite)

func _physics_process(delta: float) -> void:
    var input_dir := Vector2(
        Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
        Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    ).normalized()

    velocity = input_dir * speed
    move_and_slide()

    attack_timer = max(0.0, attack_timer - delta)
    if Input.is_action_just_pressed("ui_accept") and attack_timer <= 0.0:
        attack_timer = attack_cooldown
        perform_attack()

func perform_attack() -> void:
    var radius := 48.0
    for en in get_tree().get_nodes_in_group("enemies"):
        if en and en.is_inside_tree():
            if en.global_position.distance_to(global_position) <= radius:
                if en.has_method("take_damage"):
                    en.call("take_damage", 34, "Player")

func take_damage(amount: int, source: String = "") -> void:
    hp = max(0, hp - amount)
    emit_signal("hp_changed", hp)
    if hp <= 0:
        emit_signal("player_died")
