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
signal pointerMiddle
signal pointerRotate

signal gamePaused
signal gameResume
signal gameSpeed
signal gameSpeedSet
signal gameSpeedSlower
signal gameSpeedFaster
signal gameSpeedReset
signal quitGame

signal levelStart

signal mainMenu
signal menuVanish
signal menuAppear
signal menuDidAppear
signal settingsMenu

signal menuSound
signal gameSound

signal activateBuilder
signal infoTooltip
signal infoTooltipHide

signal storageItemMax
signal storageItemEmpty
signal storageItemChange

signal delFruit
signal itemStats
signal fabState

signal itemGraphAdd
signal itemGraphDel

var sigDict : Dictionary

func _ready():
    
    sigDict = Utils.signalDict(self)
        
func subscribe(node:Node):
    
    var methDict = Utils.methodDict(node)
    for sigName in sigDict:
        if methDict.has(sigName):
            self.connect(sigName, node[sigName])
