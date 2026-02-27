extends Builder
class_name BeltBuilder

var tmpTracks : TrackState

var lastTemp
var orientation = 0
var trail = []

func _ready():
    
    cursorShape = Control.CURSOR_MOVE

func start():
    
    tmpTracks = Utils.world("Level/TempState")
    assert(tmpTracks)
    
    fabState().tmp.setBeltBuilderColors()
        
func stop():
    
    trail = []
    lastTemp = null
    clearTemp()
    
func pointerHover(pos):
    
    lastTemp = null
    clearTemp()
    addTempPoint(pos)
    
func pointerRotate():
    
    if trail.is_empty() and lastTemp and not fabState().isOccupied(lastTemp):
        var lt = fabState().tempAtPos(lastTemp)
        if Belt.isSimple(lt):
            orientation = (orientation + 1) % 4
            clearTemp()
            fabState().addTempAtPos(lastTemp, Belt.rotateType(lt))
    
func pointerContext(pos):
    
    pointerRotate()
        
func pointerClick(pos):
    
    if fabState().numTemp() == 0:
        addTempPoint(pos)
    
func addTempPoint(pos):
    
    if fabState().isOccupied(pos):
        lastTemp = pos
        return
    
    if lastTemp:
        trail.push_back(lastTemp)

    var bt = beltTypeAtPos(pos)
    
    if not bt: 
        lastTemp = pos
        return
        
    fabState().addTempAtPos(pos, bt)
    
    if lastTemp and not fabState().isOccupied(lastTemp):
        fabState().addTempAtPos(lastTemp, neighborConnect(lastTemp, 0))
        
    lastTemp = pos

func beltTypeAtPos(pos):
    
    var type = 0
    
    if lastTemp:
        type = Belt.setInput(type, Belt.dirForPositions(pos, lastTemp))

    return neighborConnect(pos, type)    
    
func neighborConnect(pos, type):
    
    var otype = type
    var tempConnected = Belt.connectNeighbors(pos, fabState().tempNeighborsAtPos(pos), type)
    
    type = Belt.connectNeighbors(pos, fabState().beltNeighborsAtPos(pos), tempConnected)
    
    if Belt.hasNoOutput(type) and lastTemp and lastTemp != pos:
        type = Belt.connectNeighbors(pos, fabState().beltNeighborsAtPos(pos), Belt.setOutput(tempConnected, Belt.dirForPositions(lastTemp, pos)))
    elif Belt.hasNoInput(type) and tempConnected:
        type = Belt.connectNeighbors(pos, fabState().beltNeighborsAtPos(pos), Belt.fixInput(tempConnected))
        
    if type == 0:
        type = Belt.I_W | Belt.O_E # 0b0001_0100
        type = Belt.orientateType(type, orientation)
        
    if Belt.noInOut(type):
        type = Belt.fixInOut(type)
        if Belt.isInvalidType(type) or Belt.noInOut(type):
            Log.warn(Belt.stringForType(type))
            return 0

    return type
             
func pointerShiftClick(pos):
    
    if fabState().numTemp() == 0:
        pointerClick(pos)
    else:
        pointerDrag(pos)
        
func popTrail():
    
    if trail.size() > 1 and fabState().tempAtPos(trail[-1]):
        fabState().addTempAtPos(trail[-1], Belt.clearOutput(fabState().tempAtPos(trail[-1]), Belt.dirForPositions(trail[-1], lastTemp)))
    fabState().delTempAtPos(lastTemp)
    lastTemp = trail.pop_back()
    
func pointerDrag(pos):
    
    if fabState().numTemp() == 0:
        return
        
    if pos == lastTemp: 
        return
        
    if not trail.is_empty() and pos == trail[-1]:
        popTrail()
        return
        
    while lastTemp.x - pos.x > 1: # interpolate horizontally
        addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        
    while lastTemp.x - pos.x < -1:
        addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    while lastTemp.y - pos.y > 1: # interpolate vertically
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y-1))
        
    while lastTemp.y - pos.y < -1:
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y+1))
    
    if lastTemp.x != pos.x and lastTemp.y != pos.y: # fill corner in diagonal case
        if lastTemp.x - pos.x > 0:
            addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        else:
            addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    addTempPoint(pos)
    
func pointerCancel(pos):
    
    stop()
    
func pointerRelease(p):
    
    if fabState().numTemp() == 0:
        return
        
    for i in range(fabState().numTemp()):
        var tmp = fabState().tempAtIndex(i)
        if Belt.isInvalidType(tmp):
            Log.warn("FIXINOUT", Belt.stringForType(tmp))
            tmp = Belt.fixInOut(tmp)
            if Belt.isInvalidType(tmp):
                Log.warn("RELEASE", Belt.stringForType(tmp))
        
        fabState().addBeltAtPos(fabState().tempPosAtIndex(i), tmp)    
        
    lastTemp = null
    trail = []
    clearTemp()
    
