class_name IconButtonGrid
extends Control

signal buttonPressed

@export var buttonSize : float = 96
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
    button.custom_minimum_size = Vector2(buttonSize, buttonSize)
    button.expand_icon = true
    %Grid.add_child(button)

func onButtonPressed(button):
    
    buttonPressed.emit(button.icon.resource_path.get_file().get_basename())
    
func setNumber(index: int, number : int):
    
    var button : Button = buttonGroup.get_buttons()[index]
    button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.text = String.num_int64(number)
