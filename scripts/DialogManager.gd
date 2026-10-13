extends CanvasLayer

func show(text: String, duration: float = 2.5) -> void:
    var dlg := Panel.new()
    dlg.size = Vector2(520, 60)
    dlg.position = Vector2(380, 12)

    var lbl := Label.new()
    lbl.text = text
    lbl.position = Vector2(12, 12)
    lbl.add_theme_font_size_override("font_size", 16)
    dlg.add_child(lbl)

    add_child(dlg)
    await get_tree().create_timer(duration).timeout
    dlg.queue_free()
