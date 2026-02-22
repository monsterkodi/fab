class_name IconButtonGrid
extends Control

signal buttonPressed

@export var icons : Array[String]
var buttonGroup : ButtonGroup

func _ready():
    
    buttonGroup = ButtonGroup.new()
    buttonGroup.pressed.connect(onButtonPressed)
    for resPath in icons:
        if not resPath.is_empty():
            addIcon(resPath)
        
func addIcon(resPath):
    
    var button : Button = Button.new()
    button.button_group = buttonGroup
    button.toggle_mode = true
    button.icon = load(resPath)
    button.custom_minimum_size = Vector2(128, 128)
    button.expand_icon = true
    %Grid.add_child(button)

func onButtonPressed(button):
    
    Log.log("pressed", button.icon.resource_path.get_file().get_basename())
    buttonPressed.emit(button.icon.resource_path.get_file().get_basename())
