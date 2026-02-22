class_name BuilderSwitch
extends Node3D

var builder

func _ready():
    
    Post.subscribe(self)

func levelStart():
    
    activateBuilder("Belt")

func activateBuilder(builderName):
    
    if builder: builder.stop()
    
    var color = Color.TRANSPARENT
    
    match builderName:
        "Belt": builder = $BeltBuilder; color = Color.DODGER_BLUE
        "Del":  builder = $Deleter;     color = Color.RED
        "Rect": builder = $RectSelect;  color = Color.WHITE
        _:      builder = $BuildingBuilder; builder.setBuilding(builderName)
    
    if color == Color.TRANSPARENT:
        $Dot.visible = false
    else:
        $Dot.visible = true
        $Dot.get_surface_override_material(0).albedo_color = color
    builder.start()
    pointerHover(Vector2i($Dot.global_position.x, $Dot.global_position.z))
    
func pointerHover(pos):
    
    if builder: builder.pointerHover(pos)
    
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
