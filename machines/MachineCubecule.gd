class_name MachineCubecule
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CylinderWhite, 10], [Item.Type.CubeCross, 10], [Item.Type.Energy, 10]], "out": Item.Type.Cubecule, "time": 12.0}
    super._init(Mach.Type.Cubecule, p, o)
