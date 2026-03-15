class_name Ghost
extends Machine

var proxy : Machine
var color : Color

func _ready():

    assert(type)
    slits = Mach.slitsForType(type)
    slots = Mach.slotsForType(type)
    
    if proxy:
        proxy.hide()

    fab = get_parent().get_parent()
    mst = fab.gst
    createBuilding()
    
func setColor(c : Color): 
    
    color = c
    if bdg:
        for module in bdg.modules:
            if module.type == Module.Type.ARROW:
                if module.kind == Module.Kind.SLIT:
                    module.color = Color(4,0,0)
                elif module.kind == Module.Kind.SLOT:
                    module.color = Color(0.3,0.3,4)
            else:
                module.color = color
        mst.add(bdg)
    
func createBuilding():
    
    bdg = MachState.Building.new(type, pos, Utils.basisForOrientation(orientation))
    setColor(color)
    mst.add(bdg)
    
func _exit_tree():
    
    if proxy:
        proxy.show()

    if bdg:
        mst.del(bdg)
        bdg = null

      
