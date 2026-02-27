class_name HUD 
extends Control

func _ready():
    
    Post.subscribe(self)
    
func levelStart():
    
    activateButton(0)

func activateButton(index):    
    
    var btns = %IconButtonGrid.buttonGroup.get_buttons()
    if index >= 0 and index < btns.size():
        btns[index].button_pressed = true
    
func slower():
    Post.speedSlower.emit()

func faster():
    Post.speedFaster.emit()

func buttonPressed(buildingName : String):
   
    Post.activateBuilder.emit(buildingName.replace("Building", ""))

func _unhandled_key_input(event: InputEvent):
    
    if Input.is_action_just_pressed("delete"):
        var btn = %IconButtonGrid.buttonGroup.get_buttons()[-1]
        btn.button_pressed = true

    if Input.is_action_just_pressed("rect_select"):
        var btn = %IconButtonGrid.buttonGroup.get_buttons()[0]
        btn.button_pressed = true

    if event is InputEventKey:
        if not event.is_echo():
            if event.keycode >= KEY_1 and event.keycode <= KEY_9:
                activateButton(event.keycode-KEY_1+1)
