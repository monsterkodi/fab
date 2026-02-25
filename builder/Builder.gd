class_name Builder
extends Node3D

# Hatchery: Food + Time + Energy + Space = Produce
# Trains: Railed like belts, one model can be chained
# Mixer: Green+Red = Yellow, Red+Green+Blue = White
# Painter: Item + Color + Time + Energy = Colored Item
# Coal Burner, Shit Burner: Fuel + Time = Energy
# Shapes: Item + [Torus Sphere Cube] + Time + Energy = Converted Item
# Merger: Torus + Sphere = TorusSphere
# Spliiter: TorusSphere = Torus + Sphere

var cursorShape : Control.CursorShape = Control.CURSOR_ARROW

func start(): pass
    
func stop(): pass
    
func pointerHover(pos):      pass
func pointerClick(pos):      pass
func pointerShiftClick(pos): pass
func pointerDrag(pos):       pass
func pointerCancel(pos):     pass
func pointerContext(pos):    pass
func pointerRelease(pos):    pass
func pointerRotate():        pass

func fabState(): return Utils.fabState()
func clearTemp():  fabState().clearTemp()
func updateTemp(): fabState().updateTemp()
func updateBelt(): fabState().updateBelt()
