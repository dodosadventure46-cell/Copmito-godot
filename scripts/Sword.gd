extends Area2D

signal picked_up

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if body and body.is_in_group("player"):
        if body.has_method("equip_weapon"):
            body.call("equip_weapon", "Wooden Sword", 34)
        var lbl := Label.new()
        lbl.text = "Picked up Wooden Sword"
        lbl.add_theme_font_size_override("font_size", 16)
        lbl.position = global_position + Vector2(-24, -40)
        get_tree().current_scene.add_child(lbl)
        await get_tree().create_timer(1.5).timeout
        lbl.queue_free()
        emit_signal("picked_up")
        queue_free()
