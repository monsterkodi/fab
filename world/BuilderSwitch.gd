class_name BuilderSwitch
extends Node3D

var builder

func _ready():
    
    Post.subscribe(self)

func levelStart():
    
    activateBuilder("Belt")

func activateBuilder(builderName):
    
    if builder: builder.stop()
    
    var color = Color.WHEAT
    
    match builderName:
        "Belt": builder = $BeltBuilder; color = Color.DODGER_BLUE
        "Del":  builder = $Deleter;     color = Color.RED
        _:      builder = $BuildingBuilder; builder.setBuilding(builderName)
        
    $Dot.get_surface_override_material(0).albedo_color = color
    builder.start()
    
func pointerHover(pos):
    
    builder.pointerHover(pos)
    
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
    
func pointerRotate():
    
    builder.pointerRotate()
