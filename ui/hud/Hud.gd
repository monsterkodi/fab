class_name HUD 
extends Control

func _ready():
    
    Post.subscribe(self)
    
func levelStart():
    
    %Belt.set_pressed(true)
    
func beltToggled(on: bool):
    
    if on:
        Post.activeAction.emit("Belt")

func delToggled(on: bool):

    if on:
        Post.activeAction.emit("Del")
