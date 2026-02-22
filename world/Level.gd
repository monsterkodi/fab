class_name Level 
extends Node3D

var inert = true
@onready var fabState: FabState = $FabState

func _ready():
    
    #Log.log("Level._ready", name)
    
    fabState.addMachineAtPosOfType(Vector2i(0,0), Mach.Type.Root)
    
    set_process(false)
        
func start():
    
    Log.log("Level.start", get_path())
    add_to_group("game")
    set_process(true)
    Post.subscribe(self)
    
func gamePaused():
    
    set_physics_process(false)
    set_process(false)
    
func gameResumed():
    
    set_physics_process(true)
    set_process(true)
    
