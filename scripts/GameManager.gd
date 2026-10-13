extends Node2D

# Game Manager: quest, dialog, boss HP bar, sword pickup

const PLAYER_SCENE := preload("res://scripts/Player.gd")
const ENEMY_SCENE := preload("res://scripts/Enemy.gd")
const NPC_SCENE := preload("res://scripts/NPC.gd")
const SWORD_SCENE := preload("res://scripts/Sword.gd")
const DIALOG_SCENE := preload("res://scripts/DialogManager.gd")

var player: CharacterBody2D
var score_label: Label
var demon_king_defeated: bool = false
var boss_bar_bg: ColorRect
var boss_bar_fill: ColorRect
var boss_label: Label
var dialog_manager: Node

func _ready() -> void:
    score_label = $HUD/LabelScore
    setup_world()
    setup_player()
    setup_enemies()
    setup_npcs()
    setup_dialog_manager()
    create_sword_item()
    update_hud()

func setup_world() -> void:
    # Simple procedurally generated ground tiles (color blocks)
    var world := $World
    for x in range(0, 8):
        for y in range(0, 5):
            var block := ColorRect.new()
            block.color = Color(0.08 + randf() * 0.05, 0.2 + randf()*0.06, 0.08 + randf()*0.05)
            block.position = Vector2(x * 160, y * 140)
            block.size = Vector2(160, 140)
            world.add_child(block)

func setup_player() -> void:
    var p := $World.get_node("Player")
    p.set_script(PLAYER_SCENE)
    player = p
    player.connect("hp_changed", Callable(self, "_on_player_hp_changed"))
    player.connect("player_died", Callable(self, "_on_player_died"))

func setup_enemies() -> void:
    # Spawn a few patrol demons and one Demon King boss
    var positions := [Vector2(520, 360), Vector2(920, 420), Vector2(780, 180)]
    for pos in positions:
        var e := CharacterBody2D.new()
        e.name = "Enemy"
        e.position = pos
        e.set_script(ENEMY_SCENE)
        e.add_to_group("enemies")
        add_child(e)

    # Demon King boss
    var boss := CharacterBody2D.new()
    boss.name = "DemonKing"
    boss.position = Vector2(1100, 200)
    boss.set_script(ENEMY_SCENE)
    boss.set("is_boss", true)
    boss.add_to_group("enemies")
    add_child(boss)

    # Connect enemy signals
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if enemy and enemy.has_method("connect"):
            if enemy.name == "DemonKing" and enemy.has_signal("hp_changed"):
                enemy.connect("hp_changed", Callable(self, "_on_boss_hp_changed"))
            if enemy.has_signal("enemy_died"):
                enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))

func setup_npcs() -> void:
    var npc := Node2D.new()
    npc.name = "NPC_Tutorial"
    npc.position = Vector2(360, 320)
    var script := NPC_SCENE
    npc.set_script(script)
    add_child(npc)

func setup_dialog_manager() -> void:
    dialog_manager = DIALOG_SCENE.new()
    add_child(dialog_manager)

func create_sword_item() -> void:
    var world := $World
    var sword := Area2D.new()
    sword.name = "SwordItem"
    sword.position = Vector2(300, 520)
    sword.set_script(SWORD_SCENE)

    var collision := CollisionShape2D.new()
    var shape := CircleShape2D.new()
    shape.radius = 12
    collision.shape = shape
    sword.add_child(collision)

    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/sword.svg")
    sprite.position = Vector2(-16, -16)
    sword.add_child(sprite)

    world.add_child(sword)

func _on_enemy_died(enemy_name: String) -> void:
    if enemy_name == "DemonKing":
        demon_king_defeated = true
        update_hud()
        if dialog_manager and dialog_manager.has_method("show"):
            dialog_manager.call("show", "You defeated the Demon King! Quest complete.")

func _on_player_hp_changed(new_hp: int) -> void:
    update_hud()

func _on_player_died() -> void:
    if dialog_manager and dialog_manager.has_method("show"):
        dialog_manager.call("show", "You died. Press R to restart.")

func update_hud() -> void:
    var hp := player.hp if player and player.is_inside_tree() else 0
    var quest := "Defeated" if demon_king_defeated else "Defeat Demon King"
    score_label.text = "HP: %d | Quest: %s" % [hp, quest]

# Boss HP bar handling
func _on_boss_hp_changed(current: int, maximum: int) -> void:
    if not boss_bar_bg:
        _create_boss_bar()
    var ratio := 0.0
    if maximum > 0:
        ratio = float(current) / float(maximum)
    boss_bar_fill.size = Vector2(280 * ratio, boss_bar_fill.size.y)
    boss_label.text = "Demon King HP: %d / %d" % [current, maximum]

func _create_boss_bar() -> void:
    boss_bar_bg = ColorRect.new()
    boss_bar_bg.color = Color(0.07, 0.07, 0.07, 0.9)
    boss_bar_bg.position = Vector2(20, 60)
    boss_bar_bg.size = Vector2(300, 28)

    boss_bar_fill = ColorRect.new()
    boss_bar_fill.color = Color(0.82, 0.07, 0.07, 1.0)
    boss_bar_fill.position = Vector2(10, 6)
    boss_bar_fill.size = Vector2(280, 16)
    boss_bar_bg.add_child(boss_bar_fill)

    boss_label = Label.new()
    boss_label.position = Vector2(20, 36)
    boss_label.add_theme_font_size_override("font_size", 14)
    add_child(boss_bar_bg)
    add_child(boss_label)

func show_message(text: String) -> void:
    var dlg := Label.new()
    dlg.text = text
    dlg.add_theme_font_size_override("font_size", 20)
    dlg.position = Vector2(480, 40)
    add_child(dlg)
    await get_tree().create_timer(3.0).timeout
    dlg.queue_free()

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_R) and (player == null or player.hp <= 0 or demon_king_defeated):
        get_tree().reload_current_scene()
