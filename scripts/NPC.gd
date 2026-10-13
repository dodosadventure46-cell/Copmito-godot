extends Node2D

# Simple NPC script for interaction and tutorial guidance
func _ready() -> void:
    pass

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        var mp = get_global_mouse_position()
        if global_position.distance_to(mp) < 36:
            show_dialog()

func show_dialog() -> void:
    var dlg := Label.new()
    dlg.text = "Welcome, traveler. Your quest: defeat the Demon King. If confused, ask & create an issue."
    dlg.position = global_position + Vector2(-60, -50)
    dlg.add_theme_font_size_override("font_size", 14)
    get_tree().current_scene.add_child(dlg)
    await get_tree().create_timer(3.0).timeout
    dlg.queue_free()
