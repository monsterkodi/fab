class_name BuilderSwitch
extends Node3D

var builder

func _ready():
    
    Post.subscribe(self)

func levelStart():
    
    activateBuilder("Belt")

func activateBuilder(builderName):
    
    if builder: builder.stop()
    
    match builderName:
        "Belt": builder = $BeltBuilder
        "Del":  builder = $Deleter
        "Rect": builder = $RectSelect
        _:      builder = $BuildingBuilder 
    
    Utils.world("MouseHandler").mouse_default_cursor_shape = builder.cursorShape
    
    builder.fab = Utils.fabState()
    if builder is BuildingBuilder:
        builder.setBuilding(builderName)
    builder.start()
    
    pointerHover(Utils.world("MouseHandler").lastPos)
    
func pointerHover(pos):       builder.pointerHover(pos)
func pointerClick(pos):       builder.pointerClick(pos)                
func pointerShiftClick(pos):  builder.pointerShiftClick(pos)
func pointerDrag(pos):        builder.pointerDrag(pos)
func pointerCancel(pos):      builder.pointerCancel(pos)
func pointerContext(pos):     builder.pointerContext(pos)
func pointerRelease(pos):     builder.pointerRelease(pos)
func pointerRotate():         builder.pointerRotate()
