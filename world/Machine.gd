class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array
var slits : Array
var building

func _ready():
    
    assert(type)
    
    for slit in slits:
        #fabState().beltPieces[pos + slit.pos] = Belt.fixOutput(Belt.INPUT[slit.dir])
        fabState().beltPieces[pos + slit.pos] = Belt.INPUT[slit.dir]

    for slot in slots:
        #fabState().beltPieces[pos + slot.pos] = Belt.fixInput(Belt.OUTPUT[slot.dir])
        fabState().beltPieces[pos + slot.pos] = Belt.OUTPUT[slot.dir]
        
    for opos in getOccupied():
        fabState().machines[opos] = self
        
    fabState().updateBelt()

func _exit_tree():
    
    building.queue_free()
    
    for slot in slots:
        fabState().delBeltAtPos(pos + slot.pos)
    for slit in slits:
        fabState().delBeltAtPos(pos + slit.pos)
        
    for opos in getOccupied():
        fabState().machines.erase(opos)
    
func setBuilding(node):
    
    building = node
    Utils.level().add_child(building)
    
func setOrientation(orientation):

    for slot in slots:
        slot.pos = Belt.orientatePos(orientation, slot.pos)
        slot.dir = Belt.orientateDir(orientation, slot.dir)
        
    for slit in slits:
        slit.pos = Belt.orientatePos(orientation, slit.pos)
        slit.dir = Belt.orientateDir(orientation, slit.dir)
    
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
        
