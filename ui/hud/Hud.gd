class_name HUD 
extends Control

var storage : ItemStorage

func _ready():
    
    Post.subscribe(self)
    
    $BuildButtonGrid.addButton("res://icons/buildings/BuildingRect.png", "Rect")
    
    for type in Mach.Types:
        if type == Mach.Type.Belt:
            $BuildButtonGrid.addButton("res://icons/buildings/BuildingBelt.png", type)
        else:
            $BuildButtonGrid.addButton("res://icons/machines/" + Mach.stringForType(type) + ".png", type)
        
    $BuildButtonGrid.addButton("res://icons/buildings/BuildingDel.png", "Del")
    
func _process(delta: float):
    
    if not storage: return

    for itemType in storage.storage:
        if storage.storage[itemType] < storage.maxItem:
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
    
func buttonPressed(buildingName : String):
   
    Post.activateBuilder.emit(buildingName.replace("Building", ""))

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

func _unhandled_key_input(event: InputEvent):
    
    if event is InputEventKey:
        if event.pressed and not event.is_echo():
            if event.keycode >= KEY_1 and event.keycode <= KEY_9:
                activateButton(event.keycode-KEY_1+1)

func itemButtonPressed(itemName : String):

    for i in range(50):
        Utils.fabState().storage.addItem(Item.typeForString(itemName.replace("Item", "")))

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
