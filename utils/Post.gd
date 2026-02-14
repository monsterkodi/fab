extends Node

signal pointerHover
signal pointerClick
signal pointerDrag
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
signal newGame
signal resumeGame
signal settings
signal quitGame

var sigDict : Dictionary

func _ready():
    
    sigDict = Utils.signalDict(self)
        
func subscribe(node:Node):
    
    var methDict = Utils.methodDict(node)
    for sigName in sigDict:
        if methDict.has(sigName):
            self.connect(sigName, node[sigName])
