Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'spaceships',
		'dice',
		'battle',
		'activePermanentCards',
		'cardsThrown',
		'lastTileEffectApplied',
		'turnIndex'
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

{ #category : 'behavior' }
Game >> activePermanentCards [
    ^ activePermanentCards deepCopy.
]

{ #category : 'accessing' }
Game >> addActivePermanentCard: aCard [
    "NUEVO"
    activePermanentCards add: aCard.
]

{ #category : 'initialization' }
Game >> board [
    ^ board
]

{ #category : 'behavior' }
Game >> calculateTotalRollFor: aSpaceship [

	| baseRoll |
	"NUEVO"
	baseRoll := self getAllDiceValuesFrom: dice.
	^ activePermanentCards
		  inject: baseRoll
		  into: [ :currentTotal :eachCard |
			  eachCard applyBonusTo: currentTotal for: aSpaceship ]
]

{ #category : 'accessing' }
Game >> checkForBattleInvolving: aSpaceship [
	battle checkForBattleIfNeededWith: aSpaceship.
]

{ #category : 'testing' }
Game >> checkIfGameHasAlreadyFinished [

	(board hasAnySpaceshipFinished: spaceships) ifTrue: [
		Error signal: 'Cannot play a turn after the game has finished.' ].
]

{ #category : 'behavior' }
Game >> checkValid: aTargetSpaceship for: spaceship inCard: aCard [

	|spaceshipSearch|
    spaceshipSearch := (spaceships select: [ :s | s ~= spaceship ]).
    spaceshipSearch := spaceshipSearch detect: [ :s | s = aTargetSpaceship ]  ifNone: [ ^ nil].
	 spaceshipSearch hasOwner  ifTrue: [ ^ nil ].
	 ^ spaceshipSearch.
    
]

{ #category : 'behavior' }
Game >> getAllDiceValuesFrom: diceCollection [

	^ diceCollection
		  inject: 0
		  into: [ :sumOfValues :aDie | sumOfValues + aDie roll ]
]

{ #category : 'behavior' }
Game >> getPositionTable [
    (board hasAnySpaceshipFinished: spaceships) ifFalse: [ self error: 'Cannot get position table before game ends.' ].
    ^ board createPositionTable: spaceships.

]

{ #category : 'behavior' }
Game >> getRealCard: aTargetCard [
	"ROMPE INMUTABILIDAD"
     ^ activePermanentCards 
        detect: [ :each | each = aTargetCard ] 
        ifNone: [ Error signal: 'Cannot cancel a card that is not active' ].
]

{ #category : 'accessing' }
Game >> hasFinished [ 
	^ board hasAnySpaceshipFinished: spaceships.
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: aCollectionOfSpacehips and: aCollectionOfDice [

	spaceships := aCollectionOfSpacehips deepCopy.
	board := aBoard.
	dice := aCollectionOfDice.
	battle := Battle with: spaceships and: dice.
	activePermanentCards := OrderedCollection new.
	cardsThrown := NoEffectCard new.
	lastTileEffectApplied := NoEffect new.
	turnIndex := 1.

]

{ #category : 'behavior' }
Game >> isCurrentTurnOf: aSpaceship [
    ^ (spaceships at: turnIndex) == aSpaceship
]

{ #category : 'accessing' }
Game >> lastCardThrown [
    ^ cardsThrown
]

{ #category : 'accessing' }
Game >> lastTileEffectApplied [

	^ lastTileEffectApplied
]

{ #category : 'behavior' }
Game >> play: aCard by: aSpaceshipId affecting: aTargetCard targeting: aTargetShipId [

    | spaceshipInGame aSpaceshipTarget |
    spaceshipInGame := spaceships detect: [ :each | each matches: aSpaceshipId ].
    
    aSpaceshipTarget := aTargetShipId ifNotNil: [
        spaceships detect: [ :each | each matches: aTargetShipId ] ].
    
    spaceshipInGame use: aCard targeting: aTargetCard affecting: aSpaceshipTarget in: self.
]

{ #category : 'behavior' }
Game >> playCard: aCard by: aSpaceshipId targeting: aTargetSpaceship [
    self play: aCard by: aSpaceshipId affecting: (NoEffectCard new)  targeting: aTargetSpaceship
]

{ #category : 'behavior' }
Game >> playTurn [
    | spaceshipToPlay positionsToAdvance |

    self checkIfGameHasAlreadyFinished.
    spaceshipToPlay := spaceships at: turnIndex.

    (spaceshipToPlay canPlay) ifTrue: [
        positionsToAdvance := self calculateTotalRollFor: spaceshipToPlay.
        spaceshipToPlay moveBy: positionsToAdvance on: board.
        board handleLandingOf: spaceshipToPlay in: self.
    ].

    turnIndex := turnIndex \\ spaceships size + 1.
    spaceshipToPlay handleEndOfCycle.
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

{ #category : 'behavior' }
Game >> skipTurn [
    | spaceshipToPlay |

    self checkIfGameHasAlreadyFinished.
    spaceshipToPlay := spaceships at: turnIndex.
    spaceshipToPlay rechargeShields.
    turnIndex := turnIndex \\ spaceships size + 1.
    spaceshipToPlay handleEndOfCycle.


]

{ #category : 'getter' }
Game >> spaceshipMatchWith: anId [

	^ (spaceships detect: [ :each | each matches: anId ]) deepCopy.
]

{ #category : 'behavior' }
Game >> spaceshipsExcept: aSpaceship do: aBlock [
	(spaceships reject: [ :each | each = aSpaceship ]) do: aBlock

]
