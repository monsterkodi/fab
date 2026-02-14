extends Control

func _input(event: InputEvent):

    if event is InputEventMouseMotion:
        Log.log("motion", event)
                
