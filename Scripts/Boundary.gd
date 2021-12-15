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
#        if name == "Out of bounds left":
#            var left_confetti: CPUParticles2D = confetti.instance()
#            add_child( left_confetti )
#            left_confetti.global_position = area.get_global_position()
#            left_confetti.emitting = true
#            yield(get_tree().create_timer( left_confetti.lifetime ), "timeout" )
            # Free the confetti after it has burned out.
#            left_confetti.queue_free()
#            $Confetti.position = area.position
#            $Confetti.emitting = true
#        elif name == "Out of bounds right":
#            var right_confetti: CPUParticles2D = confetti.instance()
#            add_child( right_confetti )
#            right_confetti.global_position = area.get_global_position()
            # Turn it around to face the left.
#            right_confetti.scale.x = -1
#            right_confetti.emitting = true
#            yield( get_tree().create_timer( right_confetti.lifetime ), "timeout" )
#            right_confetti.queue_free()
#            $Confetti.position = area.position
#            $Confetti.emitting = true
            
        emit_signal( "scored" )
        # Reset the puck back to the center.
        area.reset()
