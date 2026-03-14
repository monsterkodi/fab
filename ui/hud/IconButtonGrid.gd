class_name IconButtonGrid
extends Control

signal buttonPressed

@export var buttonSize : float = 96
@export var icons : Array[String]

var buttonGroup : ButtonGroup
var buttonMap : Dictionary # maps type to button index

var tooltipTimer : Timer

func _ready():
    
    buttonGroup = ButtonGroup.new()
    buttonGroup.pressed.connect(onButtonPressed)
    
func addButton(iconPath : String, type):
    
    #if iconPath.contains("/items/"): Log.log(iconPath, type)
    
    var button : Button = Button.new()
    button.mouse_entered.connect(onButtonMouseEnter.bind(button))
    button.mouse_exited.connect(onButtonMouseExit.bind(button))

    button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.alignment = HORIZONTAL_ALIGNMENT_CENTER

    buttonMap[type] = buttonGroup.get_buttons().size()

    button.button_group = buttonGroup
    button.toggle_mode = true
    button.icon = load(iconPath)
    if not button.icon:
        button.text = iconPath.get_file().get_basename()
    button.custom_minimum_size = Vector2(buttonSize, buttonSize)
    button.expand_icon = true
    %Grid.add_child(button)
    
func onButtonMouseEnter(button):
    
    if not tooltipTimer:
        tooltipTimer = Timer.new()
        tooltipTimer.one_shot = true
        add_child(tooltipTimer)
    
    for connection in tooltipTimer.timeout.get_connections():
        connection.signal.disconnect(connection.callable)
    tooltipTimer.timeout.connect(onButtonTooltip.bind(button))
    if tooltipTimer.is_inside_tree():
        tooltipTimer.start(0.01)

func onButtonMouseExit(button):
    
    if tooltipTimer:
        tooltipTimer.stop()
    Post.infoTooltipHide.emit()
    
func onButtonTooltip(button):
    
    Post.infoTooltip.emit(buttonName(button), button)

func onButtonPressed(button):
    
    buttonPressed.emit(buttonName(button))
    
func buttonName(button):
    
    if button.icon:
        return button.icon.resource_path.get_file().get_basename()
    else:
        return button.text
        
func getButton(type) -> Button: 
    
    return buttonGroup.get_buttons()[buttonMap[type]]
    
func hasButton(type):
    
    return buttonMap.has(type)
    
func setNumber(type, number : int):
    
    if hasButton(type):
        getButton(type).text = String.num_int64(number)

func setTextColor(type, color : Color):
    
    if hasButton(type):
        getButton(type).add_theme_color_override("font_color", color)

func setText(type, text : String):
    
    if hasButton(type):
        getButton(type).text = text
