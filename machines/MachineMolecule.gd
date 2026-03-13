class_name MachineMolecule
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.SphereWhite, 20], [Item.Type.CylinderCross, 20], [Item.Type.CylinderBlue, 20]], "out": Item.Type.Molecule, "time": 30.0}
    super._init(Mach.Type.Molecule, p, o)
