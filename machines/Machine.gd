class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array
var slits : Array
var orientation = 0
var building
var fab : FabState

func _init(p, o):
    
    pos = p
    setOrientation(o)

func _ready():
    
    assert(type)
    
    fab = Utils.fabState()
    
    for slit in slits:
        fab.addBeltAtPos(pos + slit.pos, Belt.INPUT[slit.dir])

    for slot in slots:
        fab.addBeltAtPos(pos + slot.pos, Belt.OUTPUT[slot.dir])
        
    for opos in getOccupied():
        fab.machines[opos] = self
                
    createBuilding()

func createBuilding():
    
    building = load("res://buildings/Building%s.tscn" % Mach.stringForType(type)).instantiate()
    Utils.level().add_child(building)
    building.global_position = Vector3(pos.x, 0, pos.y)
    Utils.rotateForOrientation(building, orientation)

func _exit_tree():
    
    if building:
        building.queue_free()
    
    for slot in slots:
        fab.delBeltAtPos(pos + slot.pos)
    for slit in slits:
        fab.delBeltAtPos(pos + slit.pos)
        
    for opos in getOccupied():
        fab.machines.erase(opos)
        
func rotateCW():
    
    orientation = ((orientation + 1) % 4)

    for slot in slots:
        slot.pos = Belt.rotatePos(slot.pos)
        slot.dir = Belt.rotateDir(slot.dir)
        
    for slit in slits:
        slit.pos = Belt.rotatePos(slit.pos)
        slit.dir = Belt.rotateDir(slit.dir)
        
    if building:
        Utils.rotateCW(building)

func rotateAround(center: Vector2i):

    setPos(Belt.rotatePosAround(pos, center))
    rotateCW()
        
func setPos(p):
    
    pos = p
    building.global_position = Vector3(pos.x, 0, pos.y)

func setOrientation(o : int):
    
    orientation = o

    for slot in slots:
        slot.pos = Belt.orientatePos(o, slot.pos)
        slot.dir = Belt.orientateDir(o, slot.dir)
        
    for slit in slits:
        slit.pos = Belt.orientatePos(o, slit.pos)
        slit.dir = Belt.orientateDir(o, slit.dir)
        
    if building:
        Utils.rotateForOrientation(building, orientation)
    
func consume(delta:float):
    
    var advance = delta * 0.5
    
    for i in range(slits.size()):
        var slit = slits[i]
        var item = fab.consumableItemAtPos(pos + slit.pos, advance)
        if item:
            if consumeItemAtSlit(item, slit):
                fab.delItem(item)
    
func advanceAtSlotIndex(i):
    
    return fab.inSpace(pos + slots[i].pos, Belt.OPPOSITE[slots[i].dir])
    
func produce(delta:float):
    
    var advance = delta * 0.5
    
    for i in range(slots.size()):
        var adv = advanceAtSlotIndex(i)
        if adv >= 0:
            var item = produceItemAtSlot(slots[i])
            if item:
                item.advance = minf(advance, adv)
                fab.addItem(pos + slots[i].pos, Belt.OPPOSITE[slots[i].dir], item)
        
func produceItemAtSlot(slot): return null
func consumeItemAtSlit(item, slit): return false

func getOccupied() -> Array[Vector2i]:

    var posl : Array[Vector2i] = []
    for slot in slots:
        posl.push_back(pos + slot.pos)
    for slit in slits:
        posl.push_back(pos + slit.pos)
    if not posl.has(pos):
        posl.push_front(pos)    
    return posl
    
func isRoot(): return pos.x == 0 and pos.y == 0
        
func slitAtPos(p : Vector2i):
    
    var relPos = p - pos
    for slit in slits:
        if slit.pos == relPos:
            return slit
    return null

    
