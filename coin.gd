extends Area2D

signal collected

const COIN_TEXTURE: Texture2D = preload("res://assests/sprites/coin.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var pickup_audio: AudioStreamPlayer = $PickupAudio

var _frame := 0
var _animation_time := 0.0
var _collected := false
var _atlas_texture: AtlasTexture

func _ready() -> void:
	_atlas_texture = AtlasTexture.new()
	_atlas_texture.atlas = COIN_TEXTURE
	_atlas_texture.region = Rect2(0, 0, 16, 16)
	sprite.texture = _atlas_texture
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_animation_time += delta
	if _animation_time >= 0.08:
		_animation_time = 0.0
		_frame = (_frame + 1) % 12
		_atlas_texture.region = Rect2(_frame * 16, 0, 16, 16)

func _on_body_entered(body: Node2D) -> void:
	if _collected or not body is CharacterBody2D:
		return
	_collected = true
	collected.emit()
	monitoring = false
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.hide()
	pickup_audio.play()
	await pickup_audio.finished
	queue_free()
