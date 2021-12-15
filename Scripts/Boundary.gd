# Based upon the official Godot "Pong" demo.
# These are the "fences" that the opposing player aims for so as to score a point.
extends Area2D

onready var beep: AudioStreamPlayer = $Beep

export (PackedScene) var confetti: PackedScene

signal scored

func _on_boundary_entered( area: Area2D ) -> void:
    if area.get_name() == "Mr_puck":
        beep.play()
        # Spread some confetti.
        if name == "Out of bounds left":
            $Confetti.global_position = area.global_position
            $Confetti.emitting = true
            
        elif name == "Out of bounds right":
            $Confetti.global_position = area.global_position
            $Confetti.emitting = true
            
        emit_signal( "scored" )
        # Reset the puck back to the center.
        area.reset()
