class_name Deleter
extends Builder

const DELETE_CROSS = preload("uid://cq7q15jn2f7q5")

var ghost

func _init():
    
    cursorShape = Control.CURSOR_FORBIDDEN
    
func _ready():
    
    $Cross.hide()
    
func stop():
    
    if ghost: ghost.free()
    $Cross.hide()

func start():
    
    Utils.setOverrideMaterial($Cross, DELETE_CROSS)
    $Cross.show()
    
func pointerClick(pos):
    
    fab.sellObjectAtPos(pos)
    if ghost: ghost.free()
    
func pointerDrag(pos): 
    
    $Cross.global_position = Vector3(pos.x, 0.16, pos.y)
    pointerClick(pos)
        
func pointerHover(pos):
    
    $Cross.global_position = Vector3(pos.x, 0.16, pos.y)
    
    if fab.machines.has(pos):
        if ghost: ghost.free()
        var machine = fab.machines[pos]
        if machine.pos != Vector2i.ZERO:
            ghost = fab.ghostForMachine(machine, COLOR.GHOST_RED)
    elif ghost:
        ghost.free()    
