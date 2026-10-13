extends Node2D

func _ready() -> void:
    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/npc.svg")
    sprite.position = Vector2(-16, -16)
    add_child(sprite)

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        var mp = get_global_mouse_position()
        if global_position.distance_to(mp) < 36:
            show_dialog()

func show_dialog() -> void:
    var dlg := Label.new()
    dlg.text = "Welcome, traveler. The Demon King waits beyond the ruined gate."
    dlg.position = global_position + Vector2(-60, -50)
    dlg.add_theme_font_size_override("font_size", 14)
    get_tree().current_scene.add_child(dlg)
    await get_tree().create_timer(3.0).timeout
    dlg.queue_free()
