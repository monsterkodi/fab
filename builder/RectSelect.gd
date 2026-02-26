class_name RectSelect
extends Builder

@onready var corners: Node3D = $Corners

var startPos  : Vector2i
var endPos    : Vector2i
var isPasting := false

const MAX_SIZE = 10000

const GHOST_MATERIAL      = preload("uid://b0use4n8rmlgb")
const GHOST_BLUE_MATERIAL = preload("uid://bqhwhtt3kc30s")

func _ready():
    
    cursorShape = Control.CURSOR_CROSS
    
func start():
    
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)
    fabState().mm().setRectSelectColors()
    corners.show()

func stop():
    
    corners.hide()
    clearGhosts()
    
func pointerHover(pos):
    
    var delta = posRelativeToPointer(pos)
    startPos = pos
    endPos = pos
    if isPasting: moveGhosts(delta)
    updateCorners()

func pointerClick(pos):
    
    if isPasting: pasteGhosts()
            
    Utils.clearOverrideMaterial(corners)
        
    endPos = pos
    
    clearGhosts()
    
func clampEndPos(pos : Vector2i):
    
    var diff = pos - startPos
    var dx = diff.x
    var dy = diff.y

    var a = absi(dx * dy)
    
    if a <= MAX_SIZE:
        endPos = pos
        return
        
    var scale_factor : float = sqrt(float(MAX_SIZE) / float(a))
    var clamped_diff := Vector2(diff) * scale_factor
    endPos = startPos + Vector2i(clamped_diff.round())
        
func pointerShiftClick(pos):

    Utils.clearOverrideMaterial(corners)
        
    clampEndPos(pos)
    updateGhosts(true)
        
func pointerDrag(pos): 

    clampEndPos(pos)
    updateGhosts(Input.is_physical_key_pressed(KEY_SHIFT))
    
func pointerRelease(pos):
    
    pointerHover(pos)
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)

func pointerContext(pos):
    
    if isPasting: stopPasting()
    startPos = pos
    endPos = pos
    clearGhosts()

func clearGhosts():

    super.clearGhosts()
    clearTemp()
    updateGhosts()
    
func updateGhosts(keepOld : bool = false):

    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
    
    #Log.log("minmax", keepOld, minx, miny, maxx, maxy)

    var newGhosts : Dictionary[Vector2i, Ghost] = {}
    var newTemps  : Dictionary[Vector2i, int] = {}
    
    for x in range(minx, maxx+1):
        for y in range(miny, maxy+1):
            var pos = Vector2i(x, y)
            if fabState().machines.has(pos):
                var machine = fabState().machines[pos]
                if not newGhosts.has(machine.pos):
                    var ghost = fabState().ghostAtPos(machine.pos)
                    if not ghost:
                        ghost = fabState().ghostForMachine(machine, GHOST_MATERIAL, ["Arrow"])
                    newGhosts[machine.pos] = ghost
                    
            if fabState().beltPieces.has(pos):
                if fabState().tempPoints.has(pos):
                    fabState().tempPoints.erase(pos)
                newTemps[pos] = fabState().beltPieces[pos]

    if keepOld:
        
        for pos in fabState().tempPoints:
            if not newTemps.has(pos):
                newTemps[pos] = fabState().tempPoints[pos]
                
    else:
        for ghost in fabState().ghosts():
            if not newGhosts.has(ghost.pos):
                ghost.queue_free()

    clearTemp()
    fabState().tempPoints = newTemps
    updateTemp()
    updateBelt()
    updateCorners()

func updateCorners():
    
    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
     
    corners.get_child(0).global_position = Vector3(maxx+0.5, 0, miny-0.5)
    corners.get_child(1).global_position = Vector3(maxx+0.5, 0, maxy+0.5)
    corners.get_child(2).global_position = Vector3(minx-0.5, 0, maxy+0.5)
    corners.get_child(3).global_position = Vector3(minx-0.5, 0, miny-0.5)
    
    corners.get_child(4).scale = Vector3(maxx-minx+1, 1, maxy-miny+1)
    corners.get_child(4).global_position = Vector3((minx+maxx)/2.0, corners.get_child(4).global_position.y, (miny+maxy)/2.0)

func xyRelativeToPointer(pos : Vector2i) -> Array[int]:
    
    if endPos: return [pos.x - endPos.x, pos.y - endPos.y]
    return [0, 0]

func posRelativeToPointer(pos : Vector2i) -> Vector2i:
    
    if endPos: return pos - endPos
    return Vector2i.ZERO
    
func moveGhosts(delta : Vector2i):
    
    for ghost in fabState().ghosts():
        ghost.setPos(ghost.pos + delta)
        
    var newTemps  : Dictionary[Vector2i, int] = {}
    if not fabState().tempPoints.is_empty():
        for pos in fabState().tempPoints:
            newTemps[pos + delta] = fabState().tempPoints[pos]
        fabState().tempPoints = newTemps
    updateTemp()
    
func pasteGhosts():    
    
    for ghost in fabState().ghosts():
        fabState().addMachineAtPosOfType(ghost.pos, ghost.type, ghost.orientation)
        
    if not fabState().tempPoints.is_empty():
        for pos in fabState().tempPoints:
            fabState().addBeltAtPos(pos, fabState().tempPoints[pos])

    stopPasting()
    
func stopPasting():
    
    isPasting = false
    fabState().mm().setRectSelectColors()
    clearGhosts()
    clearTemp()
    updateGhosts()
    
func copy():
    
    var data = {"rect": {}, "machines": [], "belts": []}
    
    var minPos : Vector2i
    var maxPos : Vector2i
    
    for ghost in fabState().ghosts():
    #if not ghosts.is_empty():
        #for pos in ghosts:
        var pos = ghost.pos
        minPos.x = mini(minPos.x, pos.x)
        minPos.y = mini(minPos.y, pos.y)
        maxPos.x = maxi(maxPos.x, pos.x)
        maxPos.y = maxi(maxPos.y, pos.y)

        var machine = ghost.proxy
        var rp = xyRelativeToPointer(machine.pos)
        rp.push_back(machine.type)
        rp.push_back(machine.orientation)
        data.machines.push_back(rp)
            
    if not fabState().tempPoints.is_empty():
        for pos in fabState().tempPoints:
            minPos.x = mini(minPos.x, pos.x)
            minPos.y = mini(minPos.y, pos.y)
            maxPos.x = maxi(maxPos.x, pos.x)
            maxPos.y = maxi(maxPos.y, pos.y)
            var rp = xyRelativeToPointer(pos)
            rp.push_back(fabState().tempPoints[pos])
            data.belts.push_back(rp)
    
    data.rect["min"] = xyRelativeToPointer(minPos)
    data.rect["max"] = xyRelativeToPointer(maxPos)
    
    var string = JSON.stringify(data) 
    #Log.log("copy", string)
    DisplayServer.clipboard_set(string)    

func cut():  

    copy()
    
    for ghost in fabState().ghosts():
        fabState().delMachineAtPos(ghost.pos)
        
    if not fabState().tempPoints.is_empty():
        for pos in fabState().tempPoints:
            fabState().delBeltAtPos(pos)
            
    clearGhosts()
    clearTemp()
    updateGhosts()
        
func paste(): 

    clearGhosts()
    clearTemp()
    
    var string = DisplayServer.clipboard_get()
    if string.is_empty(): return
    var data = JSON.parse_string(string)
    if not data is Dictionary: return
    if not data.has("rect") or not data.has("belts") or not data.has("machines"): return

    var offsetX = endPos.x - (data.rect.max[0] + data.rect.min[0]) / 2
    var offsetY = endPos.y - (data.rect.max[1] + data.rect.min[1]) / 2
    
    for md in data.machines:
        var mp = Vector2i(md[0] + offsetX, md[1] + offsetY)
        var ghost = fabState().ghostForType(md[2], GHOST_BLUE_MATERIAL, ["Arrow"])
        ghost.setOrientation(md[3])
        ghost.setPos(mp)

    for bd in data.belts:
        var bp = Vector2i(bd[0] + offsetX, bd[1] + offsetY)
        fabState().tempPoints[bp] = bd[2]
    
    updateGhosts(true) 
    fabState().mm().setBeltBuilderColors()
    isPasting = true
            
func _shortcut_input(event: InputEvent):
    
    if not event.pressed: return
    #Log.log("event", event)
    if event.is_action("cut"):   cut();   get_viewport().set_input_as_handled(); return
    if event.is_action("copy"):  copy();  get_viewport().set_input_as_handled(); return
    if event.is_action("paste"): paste(); get_viewport().set_input_as_handled(); return
