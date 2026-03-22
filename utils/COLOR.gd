extends Node
# singleton COLOR

const ENERGY        := Color(0.3, 0.3, 4)
const COUNTER       := Color(0.44, 0.44, 2)
const GAUGE         := Color(0.25, 0.25, 0.25)
const BUILDING      := Color(0.1, 0.1, 0.1)
const TUNNEL        := Color(0.05, 0.05, 0.05)
const COUNTER_BOX   := Color(0.03, 0.03, 0.03)
const GAUGE_ALERT   := Color(1.5, 0.0, 0.0)
  
const SLIT          := Color(2, 0, 0)
const SLOT          := Color(0.3, 0.3, 4)
  
const SHAPE         := Color(0.1, 0.1, 0.1)
const ITEM_BLACK    := Color.BLACK
const ITEM_RED      := Color(1, 0, 0)
const ITEM_GREEN    := Color(0, 0.8, 0)
const ITEM_BLUE     := Color(0.1, 0.1, 1.0)
const ITEM_WHITE    := Color(0.8, 0.8, 0.8)
   
const GHOST_BLUE    := Color(0.15, 0.15, 1.0)
const GHOST_RED     := Color.RED

const TREE_BUILDING := Color(0.035, 0.035, 0.035)
const TREE_BRANCH   := Color(0.025, 0.025, 0.025)
const TREE_CANOPY   := Color(0.0, 0.5, 0.0)
const HUMUS         := Color(0.05, 0.05, 0.05)

const ITEM_TETRAEDER   := [ITEM_BLUE,  ITEM_RED]
const ITEM_OCTAEDER    := [ITEM_RED,   ITEM_BLUE]
const ITEM_DODECAICOSA := [ITEM_WHITE, ITEM_BLUE]
const ITEM_CUBECROSS   := [ITEM_RED,   ITEM_GREEN, ITEM_BLUE]
const ITEM_TUBECROSS   := [ITEM_GREEN, ITEM_BLUE,  ITEM_RED]
const ITEM_CUBECULE    := [ITEM_BLACK, ITEM_WHITE, ITEM_WHITE, ITEM_WHITE]
const ITEM_MOLECULE    := [ITEM_BLACK, ITEM_RED,   ITEM_GREEN, ITEM_BLUE]
