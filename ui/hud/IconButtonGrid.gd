class_name IconButtonGrid
extends Control

signal buttonPressed
signal buttonContext

@export var buttonSize : float = 96
@export var columns : int = 16
@export var tooltip : bool = false
@export var icons : Array[String]

var buttonGroup  : ButtonGroup
var buttonMap    : Dictionary # maps type to button index
var buttonTypes  : Dictionary # maps button to type
var hoverButton  : Button
var tooltipTimer : Timer

func _ready():
    
    buttonGroup = ButtonGroup.new()
    buttonGroup.pressed.connect(onButtonPressed)
    
    %Grid.columns = columns
    
func addButton(iconPath : String, type):
    
    var button : Button = Button.new()
    button.mouse_entered.connect(onButtonMouseEnter.bind(button))
    button.mouse_exited.connect(onButtonMouseExit.bind(button))

    button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.alignment = HORIZONTAL_ALIGNMENT_CENTER

    buttonMap[type] = buttonGroup.get_buttons().size()
    buttonTypes[button] = type

    button.button_group = buttonGroup
    button.toggle_mode = true
    button.icon = load(iconPath)
    if not button.icon:
        button.text = iconPath.get_file().get_basename()
    button.custom_minimum_size = Vector2(buttonSize, buttonSize)
    button.expand_icon = true
    %Grid.add_child(button)
    
func delButtons():
    
    Utils.freeChildren(%Grid)
    
    buttonGroup = ButtonGroup.new()
    buttonGroup.pressed.connect(onButtonPressed)
    
    buttonTypes = {}
    buttonMap = {}
    
func buttonPosAtIndex(index : int):
    
    return buttonGroup.get_buttons()[index].position
    
func onButtonMouseEnter(button):
    
    hoverButton = button
    
    if tooltip:
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
    
    if button == hoverButton:
        hoverButton = null
        
    if tooltip:
        if tooltipTimer:
            tooltipTimer.stop()
        Post.infoTooltipHide.emit()
    
func onButtonTooltip(button):
    
    Post.infoTooltip.emit(buttonName(button), button)

func onButtonPressed(button):
    
    buttonPressed.emit(buttonTypes[button])
    
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

func _input(event: InputEvent):
    
    if event is InputEventMouseButton:
        if hoverButton and event.button_index == 2 and event.pressed:
            buttonContext.emit(buttonName(hoverButton))
        
    
