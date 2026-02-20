class_name Level 
extends Node3D

var inert = true
@onready var fabState: FabState = $FabState

func _ready():
    
    Log.log("Level._ready", name)
    
    fabState.addMachineAtPosOfType(Vector2i(0,0), Mach.Type.Root)
    
    set_process(false)
    
    if inert:
        process_mode = Node.PROCESS_MODE_DISABLED
        #Log.log("Level._ready load inert level", name)
        loadLevel(Saver.savegame.data)
    
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
    
func clear(data:Dictionary):

    assert(data != null and data is Dictionary)
    if not data.has("Level"): data.Level = {}
                
    if not data.Level.has(name):
        save(data)
    
    var ld = data.Level[name]
    ld.player = get_node("/root/World/Player").save()
    Log.log("clear", name, data.Level[name])
    Post.levelSaved.emit(name) # to update main menu level cards

func save(data:Dictionary):
    
    if not data.has("Level"): data.Level = {}
    
    var ld = {}
    
    data.Level[name] = ld
    #Log.log("levelSaved", name)
    #Post.levelSaved.emit(name)

func loadLevel(data:Dictionary):
    
    if not data.has("Level"): return
    #Log.log("loadLevel", name, "inert", inert)
    if not data.Level.has(name): return
