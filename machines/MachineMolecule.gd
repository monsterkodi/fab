class_name MachineMolecule
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CylinderCross, 20], [Item.Type.Cubecule, 10], [Item.Type.Energy, 20]], "out": Item.Type.Molecule, "time": 12.0}
    super._init(Mach.Type.Molecule, p, o)
