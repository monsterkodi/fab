class_name MachineCylinderCross
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CylinderRed, 2], [Item.Type.CylinderGreen, 2], [Item.Type.CylinderBlue, 2]], "out": Item.Type.CylinderCross, "time": 2.0}
    super._init(Mach.Type.CylinderCross, p, o)
