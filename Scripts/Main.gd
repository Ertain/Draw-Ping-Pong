# Based upon the official Godot "Pong" demo and these other sources:
#    Original source: https://github.com/k0il/DrawingLine
#    This video: https://www.youtube.com/watch?v=lryc8feJ9sM
extends Control

var left_player_score: int = 0 setget set_left_score, get_left_score
var right_player_score: int = 0 setget set_right_score, get_right_score

export (NodePath) var winner_container_path: NodePath = @""
onready var winner_container: MarginContainer = get_node( winner_container_path )
export (NodePath) var winner_container_label_path: NodePath = @""
onready var winner_container_label: Label = get_node( winner_container_label_path )

func _ready() -> void:
    # Pause the action until "start" has been pushed.
    get_tree().set_pause(true)

# A player scored a point.
func _on_Out_of_bounds_left_scored() -> void:
    set_right_score( 1 )
    $Right_score.text = str( get_right_score() ) + '/3'

func _on_Out_of_bounds_right_scored() -> void:
    set_left_score( 1 )
    $Left_score.text = str( get_left_score() ) + "/3"

# Stuff for player 1's score.
func set_left_score( point: int ) -> void:
    left_player_score += point
    $Left_score.text = str( get_left_score() )

func get_left_score() -> int:
    if left_player_score >= 3:
        win( "Player 1" )
    return left_player_score

# Stuff for player 2's score.
func set_right_score( point: int ) -> void:
    right_player_score += point
    $Right_score.text = str( get_right_score() )

func get_right_score() -> int:
    if right_player_score >= 3:
        win( "Player 2" )
    return right_player_score

# The player won; display a message showing they won.
func win( who: String ) -> void:
    get_tree().set_pause( true )
    $Winning_sound.play()
    winner_container_label.text = who + " is the winner!"
    winner_container.show()

# Reset all the things.
func _on_Restart_button_pressed() -> void:
    left_player_score = 0
    right_player_score = 0
    $Left_score.text = "0/3"
    $Right_score.text = "0/3"
    $Left.reset()
    $Right.reset()
    $Mr_puck.reset()
    get_tree().set_pause( false )
    # Hide the window.
    winner_container.visible = not winner_container.is_visible()

# Unpause and start the game.
func _on_Start_game_pressed() -> void:
    $Title.visible = not $Title.is_visible()
    get_tree().set_pause( false )
