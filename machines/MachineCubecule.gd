class_name MachineCubecule
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CylinderWhite, 2], [Item.Type.CubeCross, 2], [Item.Type.Energy, 2]], "out": Item.Type.Cubecule, "time": 2.0}
    super._init(Mach.Type.Cubecule, p, o)
