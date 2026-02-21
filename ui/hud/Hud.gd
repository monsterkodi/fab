class_name HUD 
extends Control

func _ready():
    
    Post.subscribe(self)
    
func levelStart():
    
    %Belt.set_pressed(true)
    
func beltToggled(on: bool):   if on: Post.activateBuilder.emit("Belt")
func prismToggled(on: bool):  if on: Post.activateBuilder.emit("Prism")
func storageToggled(on: bool):if on: Post.activateBuilder.emit("Storage")

func delToggled(on: bool):

    if on:
        Post.activateBuilder.emit("Del")

func slower():
    Post.speedSlower.emit()

func faster():
    Post.speedFaster.emit()
