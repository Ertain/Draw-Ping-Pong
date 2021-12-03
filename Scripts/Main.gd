# Based upon the official Godot "Pong" demo and these other sources:
#    Original source: https://github.com/k0il/DrawingLine
#    This video: https://www.youtube.com/watch?v=lryc8feJ9sM
extends Control

var left_player_score: int = 0 setget set_left_score, get_left_score
var right_player_score: int = 0 setget set_right_score, get_right_score

onready var winner_container: MarginContainer = $Winner_container

func _ready() -> void:
    # Pause the action until "start" has been pushed.
    get_tree().set_pause(true)

func _on_Out_of_bounds_left_scored():
    set_right_score( 1 )
    $Right_score.text = str( get_right_score() )

func _on_Out_of_bounds_right_scored():
    set_left_score( 1 )
    $Left_score.text = str( get_left_score() )

func set_left_score( point: int ) -> void:
    left_player_score += point
    $Left_score.text = str( get_left_score() )

func get_left_score() -> int:
    if left_player_score >= 3:
        win("Left player")
    return left_player_score

func set_right_score( point: int ) -> void:
    right_player_score += point
    $Right_score.text = str( get_right_score() )

func get_right_score() -> int:
    if right_player_score >= 3:
        win("Right player")
    return right_player_score

func win( who: String ):
    get_tree().set_pause( true )
    winner_container.get_node("ColorRect/VBoxContainer/Label").text = who + " is the winner!"
    winner_container.show()

func _on_Restart_button_pressed():
    left_player_score = 0
    right_player_score = 0
    $Left_score.text = "00"
    $Right_score.text = "00"
    $Mr_puck.reset()
    $Left.clear_field()
    $Right.clear_field()
    get_tree().set_pause( false )
    # Hide the window.
    winner_container.visible = ! winner_container.is_visible()

# Unpause and start the game.
func _on_Start_game_pressed() -> void:
    $Title.visible = not $Title.is_visible()
    get_tree().set_pause( false )
