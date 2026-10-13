extends Area2D

signal collected

func _ready() -> void:
    add_to_group("coins")
    body_entered.connect(_on_body_entered)

    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/coin.svg")
    sprite.position = Vector2(-8, -8)
    add_child(sprite)

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("collected")
        queue_free()
