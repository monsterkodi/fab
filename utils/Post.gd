extends Node

signal loadGame
signal saveGame
signal newGame
signal resumeGame
signal continueGame

signal pointerHover
signal pointerDrag
signal pointerClick
signal pointerRelease
signal pointerShiftClick
signal pointerShiftRelease
signal pointerCancel
signal pointerContext
signal pointerRotate

signal gamePaused
signal gameResume
signal startLevel
signal retryLevel
signal clearLevel
signal levelStart
signal levelReset
signal levelEnd
signal levelLoaded
signal levelSaved
signal mainMenu
signal menuVanish
signal menuAppear
signal menuDidAppear
signal menuSound
signal gameSound
signal gameLoop
signal settingsMenu
signal quitGame
signal speedSlower
signal speedFaster
signal gameSpeed

signal activateBuilder

var sigDict : Dictionary

func _ready():
    
    sigDict = Utils.signalDict(self)
        
func subscribe(node:Node):
    
    var methDict = Utils.methodDict(node)
    for sigName in sigDict:
        if methDict.has(sigName):
            self.connect(sigName, node[sigName])
