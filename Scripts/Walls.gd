# Code taken from the Godot "Pong" demo.
extends Area2D

export var _bounce_direction: int = 1

func _ready():
    $Beep.get_stream().set_loop(false)

func _on_area_entered( area: Area2D ):
    if area.get_name() == "Mr_puck":
        $Beep.play()
        area.direction = ( area.direction + Vector2( 0.0, _bounce_direction ) ).normalized()
