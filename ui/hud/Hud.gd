class_name HUD 
extends Control

var storage : ItemStorage

var buttonGroups = [
    ["Rect"],
    ["Belt"],
    ["Tunnel", "Tunnel2", "Tunnel3"],
    ["Storage", "Counter"],
    ["Prism", "Mixer"],
    ["Burner"],
    ["Whitener", "Cylinder", "Sphere"],
    ["CubeCross", "TubeCross", "Cubecule", "Molecule"],
    ["Tree", "Root"],
    ["Sorter", "Overflow"],
    ["Humus", "Farm", "Ranch"],
    ["Del"]
]

func _ready():
    
    Post.subscribe(self)
    
    for group in buttonGroups:
        $BuildButtonGrid.addButton(iconForString(group[0]), group[0])
    
    $BuildGroupGrid.hide()
    
func iconForString(string : String):
    
    match string:
        "Rect": return "res://icons/buildings/BuildingRect.png"
        "Belt": return "res://icons/buildings/BuildingBelt.png"
        "Del" : return "res://icons/buildings/BuildingDel.png"
        _ : return "res://icons/machines/" + string + ".png"
        
func groupIndexForString(string : String):
    
    for index in buttonGroups.size():
        var group = buttonGroups[index]
        for item in group:
            if item == string:
                return index
    return -1
    
func _process(delta: float):
    
    if not storage: return

    for itemType in storage.storage:
        if storage.storage[itemType] < storage.maxItem or itemType == Item.Type.Energy:
            if %ItemButtonGrid.hasButton(itemType):
                %ItemButtonGrid.setNumber(itemType, storage.storage[itemType])
    
func levelStart():
    
    storage = Utils.fabState().storage

    for type in Item.Types:
        if storage.storage[type]:
            $ItemButtonGrid.addButton(Item.iconResForType(type), type)
            if storage.storage[type] == storage.maxItem:
                storageItemMax(type)

    activateButton(0)
    
func activateButton(index):    
    
    var btns = %BuildButtonGrid.buttonGroup.get_buttons()
    if index >= 0 and index < btns.size():
        btns[index].button_pressed = true
    
func _shortcut_input(event: InputEvent):
    
    if not event.pressed: return

    if event.is_action("delete"):
        var btn = %BuildButtonGrid.buttonGroup.get_buttons()[-1]
        btn.button_pressed = true
        get_viewport().set_input_as_handled()
        return
        
    if event.is_action("rect_select"):
        var btn = %BuildButtonGrid.buttonGroup.get_buttons()[0]
        btn.button_pressed = true
        get_viewport().set_input_as_handled()
        return
        
    if event.is_action("gameSpeedFaster"): 
        Post.gameSpeedFaster.emit()
        get_viewport().set_input_as_handled()
        return

    if event.is_action("gameSpeedSlower"): 
        Post.gameSpeedSlower.emit()
        get_viewport().set_input_as_handled()
        return

    if event.is_action("gameSpeedReset"): 
        Post.gameSpeedReset.emit()
        get_viewport().set_input_as_handled()
        return
        
    if event.is_action("hide_hud"):
        if %ItemButtonGrid.anchor_top < 0:
            slideIn()
        else:
            slideOut()
        get_viewport().set_input_as_handled()
        return

func _unhandled_key_input(event: InputEvent):
    
    if event is InputEventKey:
        if event.pressed and not event.is_echo():
            if event.keycode >= KEY_1 and event.keycode <= KEY_9:
                activateButton(event.keycode-KEY_1+1)

func buildingButtonPressed(buildingName : String):

    Post.activateBuilder.emit(buildingName)

func buildingButtonContext(buildingName : String):
    
    var groupIndex = groupIndexForString(buildingName)
    var group = buttonGroups[groupIndex]
    if group.size() > 1:
        $BuildGroupGrid.delButtons()
        for itemIndex in range(group.size()-1, -1, -1):
            var item = group[itemIndex]
            $BuildGroupGrid.addButton(iconForString(item), item)
        $BuildGroupGrid.reset_size()
        var buttonPos = %BuildButtonGrid.buttonPosAtIndex(groupIndex)
        $BuildGroupGrid.position = Vector2(buttonPos.x + %BuildButtonGrid.position.x, 1080 - group.size() * ($BuildGroupGrid.buttonSize + 8))
        $BuildGroupGrid.show()

func groupButtonPressed(buildingName : String):
    
    var index = groupIndexForString(buildingName)
    while buttonGroups[index][0] != buildingName:
        buttonGroups[index].push_back(buttonGroups[index].pop_front()) 
        
    $BuildButtonGrid.delButtons()
    for group in buttonGroups:
        $BuildButtonGrid.addButton(iconForString(group[0]), group[0])
    
    $BuildGroupGrid.hide()
    Post.activateBuilder.emit(buildingName)

func infoTooltip(string : String, button : Button):
    
    $BuildGroupGrid.hide()
    
func itemButtonPressed(itemType : Item.Type):

    Utils.fabState().storage.addItems(itemType, 100)

func throttleValue(value: float):
    
    Post.gameSpeedSet.emit(1.0 + value * 10)
    
func gameSpeed(value):
    
    %Throttle.set_value_no_signal((value-1.0)/10.0)
    
func storageItemMax(type):
    
    %ItemButtonGrid.setText(type, "10k")
    %ItemButtonGrid.setTextColor(type, Color(0.3, 0.3, 0.3))

func storageItemEmpty(type):
    
    %ItemButtonGrid.setTextColor(type, Color.RED)

func storageItemChange(type):
    
    if not %ItemButtonGrid.hasButton(type):
        $ItemButtonGrid.addButton(Item.iconResForType(type), type)
    
    %ItemButtonGrid.setTextColor(type, Color(0.7, 0.7, 0.7))
    
func slideInItems():     Utils.slideAnchorVertical(  %ItemButtonGrid,   -0.15, 0.0)
func slideInBuild():     Utils.slideAnchorVertical(  %BuildButtonGrid,   1.1,  1.0)
func slideInThrottle():  Utils.slideAnchorHorizontal(%ThrottleContainer, 1.1,  1.0)

func slideOutItems():    Utils.slideAnchorVertical(  %ItemButtonGrid,    %ItemButtonGrid.anchor_top, -0.15, 0.2, false)
func slideOutBuild():    Utils.slideAnchorVertical(  %BuildButtonGrid,   %BuildButtonGrid.anchor_top,  1.1,  0.2, false)
func slideOutThrottle(): Utils.slideAnchorHorizontal(%ThrottleContainer, %ThrottleContainer.anchor_left,  1.1,  0.2, false)

func slideIn():
    
    slideInItems()
    slideInBuild()
    slideInThrottle()
    
func slideOut():

    slideOutItems()
    slideOutBuild()
    slideOutThrottle()
    
    
