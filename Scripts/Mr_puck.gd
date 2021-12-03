# Based upon the official Godot "Pong" demo.
extends Area2D

const NORMAL_SPEED: int = 200

var _speed: int = NORMAL_SPEED
# Don't know if this should immediately go to the left.
var direction: Vector2 = Vector2.LEFT

# Save the local position so as to reset the pack back to the center.
onready var _initial_position = position

# Give the starting direction a bit of randomness.
func _ready() -> void:
    randomize()
    var result: Vector2 = _flip_a_coin()
    direction = result

# Move that mother pucker.
func _process( change_in_frame: float ):
    _speed += change_in_frame * 2
    position += _speed * change_in_frame * direction

func reset() -> void:
    var result: Vector2 = _flip_a_coin()
    direction = result
    position = _initial_position
    _speed = NORMAL_SPEED

func _flip_a_coin() -> Vector2:
    if randf() < 0.5:
        return Vector2.LEFT
    else:
        return Vector2.RIGHT
