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
    
    #if icons.size():
        #setIcons(icons)
        
#func setIcons(icns):
    #
    #icons = icns
    #for resPath in icons:
        #if not resPath.is_empty():
            #addIcon(resPath)
        
func addIcon(resPath, type):
    
    var button : Button = Button.new()
    button.mouse_entered.connect(onButtonMouseEnter.bind(button))
    button.mouse_exited.connect(onButtonMouseExit.bind(button))

    button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
    button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.alignment = HORIZONTAL_ALIGNMENT_CENTER

    buttonMap[type] = buttonGroup.get_buttons().size()

    button.button_group = buttonGroup
    button.toggle_mode = true
    button.icon = load(resPath)
    if not button.icon:
        button.text = resPath.get_file().get_basename()
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
    
func setNumber(type, number : int):
    
    var button = getButton(type)
    button.text = String.num_int64(number)

func setTextColor(type, color : Color):
    
    var button = getButton(type)
    button.add_theme_color_override("font_color", color)

func setText(type, text : String):
    
    var button = getButton(type)
    button.text = text
