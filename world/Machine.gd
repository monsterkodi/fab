class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array
var slits : Array
var orientation = 0
var building

func _ready():
    
    assert(type)
    
    for slit in slits:
        fabState().beltPieces[pos + slit.pos] = Belt.INPUT[slit.dir]

    for slot in slots:
        fabState().beltPieces[pos + slot.pos] = Belt.OUTPUT[slot.dir]
        
    for opos in getOccupied():
        fabState().machines[opos] = self
                
    fabState().updateBelt()

    building = load("res://buildings/Building%s.tscn" % Mach.stringForType(type)).instantiate()
    Utils.level().add_child(building)
    building.global_position = Vector3(pos.x, 0, pos.y)
    building.transform = building.transform.rotated_local(Vector3.UP, deg_to_rad(orientation * -90))

func _exit_tree():
    
    if building: building.queue_free()
    
    for slot in slots:
        fabState().delBeltAtPos(pos + slot.pos)
    for slit in slits:
        fabState().delBeltAtPos(pos + slit.pos)
        
    for opos in getOccupied():
        fabState().machines.erase(opos)
        
func setOrientation(o):
    
    orientation = o

    for slot in slots:
        slot.pos = Belt.orientatePos(o, slot.pos)
        slot.dir = Belt.orientateDir(o, slot.dir)
        
    for slit in slits:
        slit.pos = Belt.orientatePos(o, slit.pos)
        slit.dir = Belt.orientateDir(o, slit.dir)
    
func consume():
    
    for i in range(slits.size()):
        var slit = slits[i]
        var bs = fabState().beltStateAtPos(pos + slit.pos)
        if bs and bs.get_child_count():
            var item = bs.get_child(0)
            if item.advance >= 1:
                if consumeItemAtSlit(item, slit):
                    item.queue_free()
    
func advanceAtSlotIndex(i):
    
    var slot = slots[i]
    var bs = fabState().beltStateAtPos(pos + slot.pos)
    var inDir = Belt.OPPOSITE[slot.dir]
    return bs.inSpace(inDir)
    
func produce():
    
    for i in range(slots.size()):
        var adv = advanceAtSlotIndex(i)
        if adv >= 0:
            var item = produceItemAtSlot(slots[i])
            if item:
                var bs = fabState().beltStateAtPos(pos + slots[i].pos)
                bs.addItem(Belt.OPPOSITE[slots[i].dir], item)
        
func produceItemAtSlot(slot): return null
func consumeItemAtSlit(item, slit): return false

func fabState(): return Utils.fabState()

func getOccupied() -> Array[Vector2i]:

    var posl : Array[Vector2i] = []
    for slot in slots:
        posl.push_back(pos + slot.pos)
    for slit in slits:
        posl.push_back(pos + slit.pos)
    if not posl.has(pos):
        posl.push_front(pos)    
    return posl
        
