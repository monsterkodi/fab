class_name Deleter
extends Builder

var ghost

const GHOST_MATERIAL = preload("uid://b35kuqwv15nfr")

func _init():
    
    cursorShape = Control.CURSOR_FORBIDDEN
    
func _ready():
    
    $Cross.hide()
    
func stop():
    
    if ghost: ghost.free()
    $Cross.hide()

func start():
    
    $Cross.show()
    
func pointerClick(pos):
    
    fab.delObjectAtPos(pos)
    if ghost: ghost.free()
    
func pointerDrag(pos): 
    
    $Cross.global_position = Vector3(pos.x, 0, pos.y)
    pointerClick(pos)
        
func pointerHover(pos):
    
    $Cross.global_position = Vector3(pos.x, 0, pos.y)
    
    if fab.machines.has(pos):
        if ghost: ghost.free()
        var machine = fab.machines[pos]
        if machine.pos != Vector2i.ZERO:
            ghost = fab.ghostForMachine(machine, GHOST_MATERIAL)
    elif ghost:
        ghost.free()    
