class_name RectSelect
extends Builder

@onready var corners: Node3D = $Corners

var startPos
var endPos

var ghosts : Dictionary[Vector2i, Ghost]
const GHOST_MATERIAL = preload("uid://b0use4n8rmlgb")

func _ready():
    
    cursorShape = Control.CURSOR_CROSS
    
func start():
    
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)
    corners.show()

func stop():
    
    corners.hide()
    clearGhosts()
    
func pointerHover(pos):
    
    startPos = pos
    endPos = pos
    updateCorners()

func pointerClick(pos):
    
    clearGhosts()
    Utils.clearOverrideMaterial(corners)
        
    endPos = pos
    updateGhosts()
    updateCorners()
        
func pointerDrag(pos): 

    endPos = pos
    updateGhosts()
    updateCorners()
    
func pointerRelease(pos):
    
    pointerHover(pos)
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)

func pointerCancel(pos):
    
    startPos = pos
    endPos = pos
    clearGhosts()
    updateGhosts()
    updateCorners()

func updateCorners():
    
    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
     
    corners.get_child(0).global_position = Vector3(maxx, 0, miny)
    corners.get_child(1).global_position = Vector3(maxx, 0, maxy)
    corners.get_child(2).global_position = Vector3(minx, 0, maxy)
    corners.get_child(3).global_position = Vector3(minx, 0, miny)
    
    corners.get_child(4).scale = Vector3(maxx-minx+1, 1, maxy-miny+1)
    corners.get_child(4).global_position = Vector3((minx+maxx)/2.0, corners.get_child(4).global_position.y, (miny+maxy)/2.0)

func clearGhosts():
    
    for ghost in ghosts:
        ghosts[ghost].queue_free()
    ghosts.clear()
    
func updateGhosts():

    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
    
    var newGhosts : Dictionary[Vector2i, Ghost] = {}
    for x in range(minx, maxx+1):
        for y in range(miny, maxy+1):
            var pos = Vector2i(x, y)
            if Utils.fabState().machines.has(pos):
                var machine = Utils.fabState().machines[pos]
                if ghosts.has(pos):
                    newGhosts[pos] = ghosts[pos]
                    ghosts.erase(pos)
                else:
                    newGhosts[pos] = Utils.fabState().ghostForMachine(machine, GHOST_MATERIAL, ["Arrow"])

    clearGhosts()
    ghosts = newGhosts

func cut():  

    if not ghosts.is_empty():
        Log.log("cut")
        
func paste(): 
    
    if not ghosts.is_empty():
        Log.log("paste")

func _unhandled_key_input(event: InputEvent):
    
    if Input.is_action_just_pressed("cut"):    cut();   return
    if Input.is_action_just_pressed("paste"):  paste(); return
