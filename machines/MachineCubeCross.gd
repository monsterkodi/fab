class_name MachineCubeCross
extends MachineAssembler

func _init(p, o):
    
    recipe = {"in": [[Item.Type.CubeRed, 2], [Item.Type.CubeGreen, 2], [Item.Type.CubeBlue, 2]], "out": Item.Type.CubeCross, "time": 2.0}
    super._init(Mach.Type.CubeCross, p, o)
