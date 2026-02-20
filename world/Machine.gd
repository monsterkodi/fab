class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array

func _ready():
    
    assert(type)
    
    #Log.log("New Machine", Mach.stringForType(type))
    var fabState = Utils.fabState()
    for slot in slots:
        #Log.log("slot", slot.pos, slot.type)
        fabState.beltPieces[pos + slot.pos] = Belt.fixInput(Belt.OUTPUT[slot.dir])
        
    fabState.updateBelt()
    
func _exit_tree():
    
    Log.log("exit", name)
    Utils.fabState().machines.erase(pos)    

func consume():
    
    pass
    
func produce():
    
    for i in range(slots.size()):
        var slot = slots[i]
        var bs = Utils.fabState().beltStateAtPos(pos + slot.pos)
        var inDir = Belt.OPPOSITE[slot.dir]
        var adv = bs.inSpace(inDir)
        if adv >= 0:
            bs.addItem(inDir, Item.new())
        
