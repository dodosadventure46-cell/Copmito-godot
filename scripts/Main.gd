extends Node2D

const PLAYER_SCRIPT = preload("res://scripts/Player.gd")
const ENEMY_SCRIPT = preload("res://scripts/Enemy.gd")
const COIN_SCRIPT = preload("res://scripts/Coin.gd")

var player: CharacterBody2D
var score_label: Label
var message_label: Label
var score: int = 0
var total_coins: int = 0
var game_over: bool = false

func _ready() -> void:
    create_background()
    create_ground()
    create_walls()
    create_player()
    create_coins()
    create_enemies()
    create_hud()
    player.player_died.connect(_on_player_died)

func _process(_delta: float) -> void:
    if game_over and Input.is_key_pressed(KEY_R):
        get_tree().reload_current_scene()

func create_background() -> void:
    var bg := ColorRect.new()
    bg.color = Color(0.09, 0.12, 0.18, 1.0)
    bg.size = Vector2(1280, 720)
    add_child(bg)

func create_ground() -> void:
    var ground := StaticBody2D.new()
    ground.position = Vector2(640, 670)
    ground.name = "Ground"

    var shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(1280, 100)
    shape.shape = rect
    ground.add_child(shape)

    var visual := ColorRect.new()
    visual.position = Vector2(-640, -50)
    visual.size = Vector2(1280, 100)
    visual.color = Color(0.26, 0.46, 0.27, 1.0)
    ground.add_child(visual)

    add_child(ground)

func create_walls() -> void:
    var walls := [
        {"pos": Vector2(200, 350), "size": Vector2(220, 30)},
        {"pos": Vector2(800, 280), "size": Vector2(260, 30)},
        {"pos": Vector2(1060, 500), "size": Vector2(200, 30)},
    ]

    for wall_data in walls:
        var wall := StaticBody2D.new()
        wall.position = wall_data["pos"]
        wall.name = "Wall"

        var collision := CollisionShape2D.new()
        var shape := RectangleShape2D.new()
        shape.size = wall_data["size"]
        collision.shape = shape
        wall.add_child(collision)

        var visual := Sprite2D.new()
        visual.texture = load("res://assets/stone_wall.svg")
        visual.position = Vector2(-wall_data["size"].x / 2.0, -wall_data["size"].y / 2.0)
        visual.scale = Vector2(wall_data["size"].x / 32.0, wall_data["size"].y / 32.0)
        wall.add_child(visual)

        add_child(wall)

func create_player() -> void:
    player = CharacterBody2D.new()
    player.name = "Player"
    player.position = Vector2(140, 560)
    player.set_script(PLAYER_SCRIPT)
    player.add_to_group("player")

    var collision := CollisionShape2D.new()
    var shape := RectangleShape2D.new()
    shape.size = Vector2(20, 20)
    collision.shape = shape
    player.add_child(collision)

    var sprite := Sprite2D.new()
    sprite.texture = load("res://assets/player.svg")
    sprite.position = Vector2(-16, -16)
    sprite.scale = Vector2(1.0, 1.0)
    player.add_child(sprite)

    add_child(player)

func create_coins() -> void:
    var coin_positions := [
        Vector2(260, 285),
        Vector2(470, 360),
        Vector2(710, 245),
        Vector2(890, 215),
        Vector2(1080, 460),
    ]

    for pos in coin_positions:
        var coin := Area2D.new()
        coin.position = pos
        coin.name = "Coin"
        coin.set_script(COIN_SCRIPT)

        var collision := CollisionShape2D.new()
        var shape := CircleShape2D.new()
        shape.radius = 10
        collision.shape = shape
        coin.add_child(collision)

        var sprite := Sprite2D.new()
        sprite.texture = load("res://assets/coin.svg")
        sprite.position = Vector2(-8, -8)
        coin.add_child(sprite)

        coin.collected.connect(_on_coin_collected)
        add_child(coin)
        total_coins += 1

func create_enemies() -> void:
    var enemy_positions := [
        Vector2(420, 610),
        Vector2(760, 610),
        Vector2(940, 230),
    ]

    for pos in enemy_positions:
        var enemy := CharacterBody2D.new()
        enemy.position = pos
        enemy.name = "Enemy"
        enemy.set_script(ENEMY_SCRIPT)
        enemy.add_to_group("enemies")
        enemy.min_x = pos.x - 80
        enemy.max_x = pos.x + 80

        var collision := CollisionShape2D.new()
        var shape := RectangleShape2D.new()
        shape.size = Vector2(20, 20)
        collision.shape = shape
        enemy.add_child(collision)

        var sprite := Sprite2D.new()
        sprite.texture = load("res://assets/enemy.svg")
        sprite.position = Vector2(-16, -16)
        enemy.add_child(sprite)

        add_child(enemy)

    var boss := CharacterBody2D.new()
    boss.position = Vector2(1140, 150)
    boss.name = "DemonKing"
    boss.set_script(ENEMY_SCRIPT)
    boss.set("is_boss", true)
    boss.add_to_group("enemies")

    var boss_collision := CollisionShape2D.new()
    var boss_shape := RectangleShape2D.new()
    boss_shape.size = Vector2(28, 28)
    boss_collision.shape = boss_shape
    boss.add_child(boss_collision)

    var boss_sprite := Sprite2D.new()
    boss_sprite.texture = load("res://assets/boss.svg")
    boss_sprite.position = Vector2(-24, -24)
    boss.add_child(boss_sprite)

    add_child(boss)

func create_hud() -> void:
    var hud := CanvasLayer.new()
    hud.name = "HUD"

    score_label = Label.new()
    score_label.position = Vector2(20, 20)
    score_label.add_theme_font_size_override("font_size", 24)
    score_label.text = "Score: 0 / %d" % total_coins
    hud.add_child(score_label)

    message_label = Label.new()
    message_label.position = Vector2(20, 50)
    message_label.add_theme_font_size_override("font_size", 17)
    message_label.text = "Collect every coin!"
    hud.add_child(message_label)

    add_child(hud)

func _on_coin_collected() -> void:
    if game_over:
        return

    score += 1
    score_label.text = "Score: %d / %d" % [score, total_coins]

    if score >= total_coins:
        game_over = true
        message_label.text = "You win! Press R to restart."

func _on_player_died() -> void:
    if game_over:
        return

    game_over = true
    message_label.text = "You got caught! Press R to restart."
