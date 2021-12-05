# Based upon the official Godot "Pong" demo.
# These are the "fences" that the opposing player aims for so as to score a point.
extends Area2D

onready var beep: AudioStreamPlayer = $Beep

signal scored

func _on_boundary_entered( area: Area2D ) -> void:
    if area.get_name() == "Mr_puck":
        beep.play()
        emit_signal("scored")
        # Reset the puck back to the center. Note that the function "reset()" was written for the puck.
        area.reset()
