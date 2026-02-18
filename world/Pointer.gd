extends Node3D

var builder

func levelStart():
    
    pass
    #activeAction("Belt")

func activeAction(action):
    
    #Log.log("activeAction", action)
    
    if builder: builder.stop()
    
    var color = Color.WHEAT
    
    match action:
        "Belt": builder = $BeltBuilder; color = Color.DODGER_BLUE
        "Del":  builder = $Deleter; color = Color.RED
        _:      builder = $BeltBuilder
        
    $Dot.get_surface_override_material(0).albedo_color = color
    builder.start()

func _ready():
    
    Post.subscribe(self)
    
func pointerHover(pos):
    
    $Dot.global_position.x = pos.x
    $Dot.global_position.z = pos.y

func pointerClick(pos):

    builder.pointerClick(pos)                

func pointerShiftClick(pos):
    
    builder.pointerShiftClick(pos)

func pointerDrag(pos):
    
    pointerHover(pos)
    builder.pointerDrag(pos)

func pointerCancel(pos):
    
    builder.pointerCancel(pos)
    
func pointerRelease(pos):
    
    builder.pointerRelease(pos)
