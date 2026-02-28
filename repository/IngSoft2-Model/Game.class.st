Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'spaceships',
		'dice',
		'activePermanentCards',
		'cardsThrown',
		'lastTileEffectApplied',
		'turnManager'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'creation' }
Game class >> with: aBoard and: spaceships and: dice [
	^ self new initializeWith: aBoard and: spaceships and: dice.
]

{ #category : 'creation' }
Game class >> with: aBoard and: spaceships and: dice and: lapsToWin [
	^ self new initializeWith: aBoard and: spaceships and: dice and: lapsToWin.
]

{ #category : 'accessing' }
Game >> addActivePermanentCard: aCard [
    activePermanentCards add: aCard.
]

{ #category : 'behavior' }
Game >> calculateTotalRollFor: aSpaceship [

	| baseRoll |
	"NUEVO"
	baseRoll :=  dice
		  inject: 0
		  into: [ :sumOfValues :aDie | sumOfValues + aDie roll ].
	^ activePermanentCards
		  inject: baseRoll
		  into: [ :currentTotal :eachCard |
			  eachCard applyBonusTo: currentTotal for: aSpaceship ]
]

{ #category : 'accessing' }
Game >> checkForBattleInvolving: aSpaceship [
	(Battle new) checkIfNeededFor: aSpaceship against: spaceships using: dice.
]

{ #category : 'testing' }
Game >> checkIfGameHasAlreadyFinished [

	(board hasAnySpaceshipFinished: spaceships) ifTrue: [
		Error signal: 'Cannot play a turn after the game has finished.' ].
]

{ #category : 'behavior' }
Game >> getPositionTable [
    (board hasAnySpaceshipFinished: spaceships) ifFalse: [ self error: 'Cannot get position table before game ends.' ].
    ^ board createPositionTable: spaceships.

]

{ #category : 'behavior' }
Game >> getRealCard: aTargetCard [
     ^ activePermanentCards 
        detect: [ :each | each class = aTargetCard ] 
        ifNone: [ Error signal: 'Cannot cancel a card that is not active' ].
]

{ #category : 'initialization' }
Game >> handleLandingOf: aSpaceship [
	board handleLandingOf: aSpaceship in: self 
]

{ #category : 'behavior' }
Game >> hasActivePermanentCardOfType: aCardClass [
    ^ activePermanentCards anySatisfy: [ :card | card isKindOf: aCardClass ]
]

{ #category : 'accessing' }
Game >> hasFinished [ 
	^ board hasAnySpaceshipFinished: spaceships.
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: aCollectionOfSpaceships and: aCollectionOfDice [
	spaceships := (aCollectionOfSpaceships deepCopy).
	board := aBoard.
	dice := aCollectionOfDice.
	activePermanentCards := OrderedCollection new.
	cardsThrown := NoEffectCard new.
	lastTileEffectApplied := NoEffect new.
	turnManager := TurnManager with: spaceships.

]

{ #category : 'behavior' }
Game >> isCurrentTurnOf: aSpaceship [
    ^ turnManager isCurrentTurnOf: aSpaceship.
]

{ #category : 'behavior' }
Game >> isMaxRoll: aRoll [
    ^ aRoll = (dice inject: 0 into: [ :sum :aDie | sum + aDie maxValue ])
]

{ #category : 'accessing' }
Game >> lastCardThrown [
    ^ cardsThrown
]

{ #category : 'accessing' }
Game >> lastTileEffectApplied [

	^ lastTileEffectApplied
]

{ #category : 'testing' }
Game >> move: aSpaceship by: aDiference [ 
   board move: aSpaceship by: aDiference.
]

{ #category : 'behavior' }
Game >> play: aCard by: aSpaceshipId affecting: aTargetCard targeting: aTargetShipId [

    | spaceshipInGame aSpaceshipTarget |
    spaceshipInGame := spaceships detect: [ :each | each matchesId: aSpaceshipId ].
    
    aSpaceshipTarget := aTargetShipId ifNotNil: [
        spaceships detect: [ :each | each matchesId: aTargetShipId ] ].
    
    spaceshipInGame use: aCard targeting: aTargetCard affecting: aSpaceshipTarget in: self.
]

{ #category : 'behavior' }
Game >> playTurn [

	| spaceshipToPlay |
	self checkIfGameHasAlreadyFinished.

	spaceshipToPlay := turnManager currentSpaceship.

	spaceshipToPlay handleTurnIn: self.

	turnManager nextTurn.
	spaceshipToPlay handleEndOfCycle
]

{ #category : 'behavior' }
Game >> registerAppliedEffect: anEffect [

	lastTileEffectApplied := anEffect
]

{ #category : 'accessing' }
Game >> registerLastCardPlayed: aCard [

    cardsThrown := aCard.
]

{ #category : 'accessing' }
Game >> removeActivePermanentCard: aCard [
    activePermanentCards remove: aCard ifAbsent: [ ^ self ].
]

{ #category : 'as yet unclassified' }
Game >> reverseTurnOrder [
	turnManager reverseOrder.
]

{ #category : 'as yet unclassified' }
Game >> skipCurrentTurn [
	turnManager nextTurn.
]

{ #category : 'behavior' }
Game >> skipTurn [

    self checkIfGameHasAlreadyFinished.
    turnManager currentSpaceship rechargeShields.
    turnManager nextTurn.


]

{ #category : 'getter' }
Game >> spaceshipMatchWith: anId [

	^ (spaceships detect: [ :each | each matchesId: anId ]) deepCopy.
]

{ #category : 'behavior' }
Game >> spaceshipsDo: aBlock [
	spaceships do: aBlock

]

{ #category : 'behavior' }
Game >> spaceshipsExcept: aSpaceship do: aBlock [
	(spaceships reject: [ :each | each = aSpaceship ]) do: aBlock

]

{ #category : 'testing' }
Game >> tilesToMoveForDistance: aParsec [ 
	^ board tilesToMoveForDistance: aParsec.
]
