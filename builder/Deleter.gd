class_name Deleter
extends Builder

var ghost

const GHOST_MATERIAL = preload("uid://b35kuqwv15nfr")

func _ready():
    
    $Cross.hide()
    cursorShape = Control.CURSOR_FORBIDDEN
    
func stop():
    
    if ghost: ghost.free()
    $Cross.hide()

func start():
    
    $Cross.show()
    
func pointerClick(pos):
    
    Utils.fabState().delObjectAtPos(pos)
    if ghost: ghost.free()
    
func pointerDrag(pos): 
    
    $Cross.global_position = Vector3(pos.x, 0, pos.y)
    pointerClick(pos)
        
func pointerHover(pos):
    
    $Cross.global_position = Vector3(pos.x, 0, pos.y)
    
    if Utils.fabState().machines.has(pos):
        if ghost: ghost.free()
        var machine = Utils.fabState().machines[pos]
        if machine.pos != Vector2i.ZERO:
            ghost = Utils.fabState().ghostForMachine(machine, GHOST_MATERIAL)
    elif ghost:
        ghost.free()    
