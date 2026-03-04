class_name Builder
extends Node3D

# Burner: Item + Time = Energy
# Filter
# Tunnel
# Painter: Item + Color + Time + Energy = Colored Item
# Hatchery: Food + Time + Energy + Space = Produce
# Trains: Railed like belts, one model can, be chained
# Shapes: Item + [Torus Sphere Cube] + Time + Energy = Converted Item
# Merger: Torus + Sphere = TorusSphere
# Splitter: TorusSphere = Torus + Sphere

var cursorShape : Control.CursorShape = Control.CURSOR_ARROW
var fab : FabState # set before start is called by BuilderSwitch

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

func clearGhosts(): if fab: fab.clearGhosts()
func clearTemp():   if fab: fab.clearTemp()
