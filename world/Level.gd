class_name Level 
extends Node3D

@onready var fabState: FabState = $FabState

func _ready():
    
    Post.subscribe(fabState)
    
    set_process(false)
    
func initGame():
    
    fabState.addMachineAtPosOfType(Vector2i(0,0), Mach.Type.Root)
        
func start():
    
    Post.subscribe(self)
    set_process(true)
    
func gamePaused():
    
    set_physics_process(false)
    set_process(false)
    
func gameResumed():
    
    set_physics_process(true)
    set_process(true)
    
