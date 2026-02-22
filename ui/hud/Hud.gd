class_name HUD 
extends Control

func _ready():
    
    Post.subscribe(self)
    
func levelStart():
    
    var btn = %IconButtonGrid.buttonGroup.get_buttons()[0]
    btn.button_pressed = true
    
func slower():
    Post.speedSlower.emit()

func faster():
    Post.speedFaster.emit()

func buttonPressed(buildingName : String):
   
    Post.activateBuilder.emit(buildingName.replace("Building", ""))
