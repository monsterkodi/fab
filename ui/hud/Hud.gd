class_name HUD 
extends Control

func _ready():
    
    Post.subscribe(self)
    
    process_mode = Node.PROCESS_MODE_PAUSABLE
