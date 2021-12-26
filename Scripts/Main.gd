# Based upon the official Godot "Pong" demo and these other sources:
#    Original source: https://github.com/k0il/DrawingLine
#    This video: https://www.youtube.com/watch?v=lryc8feJ9sM
extends Control

# Keep track of those scores.
var left_player_score: int = 0 setget set_left_score, get_left_score
var right_player_score: int = 0 setget set_right_score, get_right_score

# Dialogs and panels for showing who won.
export (NodePath) var winner_container_path: NodePath = @""
onready var winner_container: MarginContainer = get_node( winner_container_path )
export (NodePath) var winner_container_label_path: NodePath = @""
onready var winner_container_label: Label = get_node( winner_container_label_path )

# Pause panel stuff
export (NodePath) var player1_pause_color_picker_path: NodePath = @""
onready var player1_pause_color_picker: ColorPickerButton = get_node( player1_pause_color_picker_path )
export (NodePath) var player2_pause_color_picker_path: NodePath = @""
onready var player2_pause_color_picker: ColorPickerButton = get_node( player2_pause_color_picker_path )

# For confetti colors.
export (NodePath) var left_confetti_path: NodePath = @""
onready var left_confetti: CPUParticles2D = get_node( left_confetti_path )
export (NodePath) var right_confetti_path: NodePath = @""
onready var right_confetti: CPUParticles2D = get_node( right_confetti_path )

func _ready() -> void:
    # Pause the action until "start" has been pushed.
    get_tree().set_pause( true )
    # Assign the default colors to the "pause" menu colors for consistency.
    player1_pause_color_picker.color = $"Title/MarginContainer/VBoxContainer/Player colors Hbox/Player 1 colors/ColorPickerButton".get_pick_color()
    player2_pause_color_picker.color = $"Title/MarginContainer/VBoxContainer/Player colors Hbox/Player 2 colors/ColorPickerButton".get_pick_color()
    # Also assign it to the confetti.
    left_confetti.color = $"Title/MarginContainer/VBoxContainer/Player colors Hbox/Player 1 colors/ColorPickerButton".get_pick_color()
    right_confetti.color = $"Title/MarginContainer/VBoxContainer/Player colors Hbox/Player 2 colors/ColorPickerButton".get_pick_color()

func _notification( what: int ) -> void:
    # Check for when the game is sent to the background on Android.
    match what:
        NOTIFICATION_APP_PAUSED:
            # Pause the action.
            get_tree().paused = true
            # Show the "pause" dialog.
            $Pause_container.visible = true

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

# A player won; display a message showing they won.
func win( who: String ) -> void:
    get_tree().set_pause( true )
    $Winning_sound.play()
    # Stop the confetti from emitting.
    left_confetti.emitting = false
    right_confetti.emitting = false
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

# Resume the action.
func _on_Resume_button_pressed() -> void:
    get_tree().paused = not get_tree().is_paused()
    $Pause_container.hide()

# Pause the action.
func _on_Pause_button_pressed() -> void:
    get_tree().paused = true
    $Pause_container.show()

# Assign the color picker in the pause menu when the player selects it at the start.
func _on_player1_color_changed( color: Color ) -> void:
    # Close the virtual keyboard since it keeps popping up when the color picker comes on-screen.
    # Answer found here:https://godotengine.org/qa/123555/how-can-i-make-the-android-keyboard-close?show=123617#a123617
    OS.hide_virtual_keyboard()
    player1_pause_color_picker.color = color
    left_confetti.color = color
    left_confetti.modulate = color

func _on_player2_color_changed( color: Color ) -> void:
    OS.hide_virtual_keyboard()
    player2_pause_color_picker.color = color
    right_confetti.color = color
    right_confetti.modulate = color
