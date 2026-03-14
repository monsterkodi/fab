class_name MachineMolecule
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CylinderCross, 10], [Item.Type.Cubecule, 10], [Item.Type.Energy, 10]], "out": Item.Type.Molecule, "time": 6.0}
    super._init(Mach.Type.Molecule, p, o)
