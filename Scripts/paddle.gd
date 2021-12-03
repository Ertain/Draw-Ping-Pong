# Some code based upon the official Godot "Pong" demo.
extends Node2D

var pressed: bool = false
var active_line: Line2D
var active_body: Area2D
var array_of_line_objects: Array = []

export (int) var _ball_direction: int = 0

export (Color) var line_color: Color = Color("#ffffff")

func _ready():
    $Beep.get_stream().set_loop(false)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton:
        if event.pressed:
            pressed = true
            # Limit the number of lines on the screen.
            if array_of_line_objects.size() < 1:
                active_line = Line2D.new()
                active_body = Area2D.new()
                active_body.connect("area_entered", self, "_on_area_entered")
                active_line.add_child( active_body )
                array_of_line_objects.append( active_line )
                active_line.default_color = line_color
                active_line.width = 10.0
            elif array_of_line_objects.size() == 1:
                var dead_line: Line2D = array_of_line_objects.pop_front()
                if dead_line == null:
                    push_error("Couldn't delete line.")
                    return
                dead_line.queue_free()
                # Add a new line.
                active_line = Line2D.new()
                active_body = Area2D.new()
                active_body.connect("area_entered", self, "_on_area_entered")
                active_line.add_child( active_body )
                array_of_line_objects.append( active_line )
                active_line.default_color = line_color
                active_line.width = 10.0
        else:
            pressed = false
    
    if event is InputEventMouseMotion:
        if pressed:
            # Shorten the number of points that make up the line.
            if active_line.get_point_count() == 10:
                active_line.remove_point( 0 )
            # Remove any left over segments after removing points. Also note that the Line2D should only have *one* child (though it could have several grandchildren).
            if active_body.get_child_count() > 7:
                active_body.get_child( 0 ).queue_free()
            # Add in the line segments.
            if active_line.get_point_count() > 2:
                # The static body has either not been created or has been freed.
                if active_body == null:
                    push_error("Collision body not available.")
                    return
                # Create a collision segment for the line to deflect the puck.
                var collision: CollisionShape2D = CollisionShape2D.new()
                collision.shape = SegmentShape2D.new()
                collision.shape.a = active_line.points[ active_line.points.size() - 1 ]
                collision.shape.b = active_line.points[ active_line.points.size() - 2 ]
                active_body.add_child( collision )
            active_line.add_point(event.position)
            if active_line.get_name() != "" and has_node( active_line.get_name() ):
                return
            add_child( active_line )

func _on_area_entered(area: Area2D):
    if area.get_name() == "Mr_puck":
        $Beep.play()
        # Assign new direction.
        area.direction = Vector2( _ball_direction, randf() * 2 - 1 ).normalized()

func clear_field():
    for node in get_children():
        if node is Line2D:
            node.queue_free()
    array_of_line_objects.clear()

# Assign player 1's color.
func _on_Player1_color_picked_changed(color: Color):
    line_color = color

# Assign player 2's color.
func _on_Player2_color_changed(color: Color) -> void:
    line_color = color
