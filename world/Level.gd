class_name Level 
extends Node3D

@onready var fabState: FabState = $FabState

func _ready():
    
    fabState.addMachineAtPosOfType(Vector2i(0,0), Mach.Type.Root)
    
    set_process(false)
        
func start():
    
    add_to_group("game")
    set_process(true)
    Post.subscribe(self)
    
func gamePaused():
    
    set_physics_process(false)
    set_process(false)
    
func gameResumed():
    
    set_physics_process(true)
    set_process(true)
    
