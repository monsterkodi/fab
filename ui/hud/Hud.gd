class_name HUD 
extends Control

var storage : ItemStorage

func _ready():
    
    Post.subscribe(self)
    
func _process(delta: float):
    
    if not storage: return
    #Log.log(storage.storage)
    for itemType in storage.storage:
        %ItemButtonGrid.setNumber(itemType, storage.storage[itemType])
    
func levelStart():
    
    storage = Utils.fabState().storage
    #Log.log("hud.levelStart", storage.storage)
    activateButton(0)
    
func activateButton(index):    
    
    var btns = %BuildButtonGrid.buttonGroup.get_buttons()
    if index >= 0 and index < btns.size():
        btns[index].button_pressed = true
    
func slower():
    Post.gameSpeedSlower.emit()

func faster():
    Post.gameSpeedFaster.emit()
    
func reset():
    Post.gameSpeedReset.emit()

func buttonPressed(buildingName : String):
   
    Post.activateBuilder.emit(buildingName.replace("Building", ""))

func _shortcut_input(event: InputEvent):
    
    if not event.pressed: return
    #Log.log("event", event)
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

func _unhandled_key_input(event: InputEvent):
    
    if event is InputEventKey:
        if event.pressed and not event.is_echo():
            if event.keycode >= KEY_1 and event.keycode <= KEY_9:
                activateButton(event.keycode-KEY_1+1)

func itemButtonPressed(itemName : String):

    for i in range(50):
        Utils.fabState().storage.addItem(Item.typeForString(itemName.replace("Item", "")))
    
