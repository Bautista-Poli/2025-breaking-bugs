Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'spaceships',
		'dice',
		'hasFinished',
		'battle',
		'lapsToWin',
		'activePermanentCards',
		'cardsThrown',
		'activatedAtomicBomb',
		'lastTileEffectApplied',
		'turnIndex',
		'remainingTurnsInCycle'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'creation' }
Game class >> with: aBoard and: spaceships and: dice and: lapsToWin [
	^ self new initializeWith: aBoard and: spaceships and: dice and: lapsToWin.
]

{ #category : 'behavior' }
Game >> activePermanentCards [
    "ROMPE INMUTABILIDAD"
    ^ activePermanentCards deepCopy.
]

{ #category : 'accessing' }
Game >> addActivePermanentCard: aCard [
    "NUEVO"
    activePermanentCards add: aCard.
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

	hasFinished ifTrue: [
		Error signal: 'Cannot play a turn after the game has finished.' ]
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
Game >> disableBattleForThisTurn [
	activatedAtomicBomb := true.
]

{ #category : 'behavior' }
Game >> endCycleIfNeeded [
	remainingTurnsInCycle := remainingTurnsInCycle - 1.
	remainingTurnsInCycle > 0 ifTrue: [ ^ self ].

	(spaceships select: [ :s | s getShields = 0 ]) do: [ :s | s penalize ].
	activatedAtomicBomb := false.
	remainingTurnsInCycle := spaceships size.



]

{ #category : 'behavior' }
Game >> getAllDiceValuesFrom: diceCollection [

	^ diceCollection
		  inject: 0
		  into: [ :sumOfValues :aDie | sumOfValues + aDie roll ]
]

{ #category : 'behavior' }
Game >> getPositionTable [
    hasFinished ifFalse: [ self error: 'Cannot get position table before game ends.' ].
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
	^ hasFinished.
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: aCollectionOfSpacehips and: aCollectionOfDice and: aNumberOfLaps [

	hasFinished := false.
	spaceships := aCollectionOfSpacehips deepCopy.
	board := aBoard.
	dice := aCollectionOfDice.
	lapsToWin := aNumberOfLaps.
	battle := Battle with: spaceships and: dice.
	activePermanentCards := OrderedCollection new.
	cardsThrown := NoEffectCard new.
	lastTileEffectApplied := NoEffect new.
	turnIndex := 1.
	remainingTurnsInCycle := aCollectionOfSpacehips size.
	activatedAtomicBomb := false.

]

{ #category : 'behavior' }
Game >> isCurrentTurnOf: aSpaceship [
    ^ (spaceships at: turnIndex) = aSpaceship
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
Game >> play: aCard by: aSpaceship affecting: aTargetCard targeting: aTargetShip [

	| spaceshipInGame aSpaceshipTarget |
	spaceshipInGame := spaceships detect: [ :each | each = aSpaceship ].
	aSpaceshipTarget := aTargetShip ifNotNil: [
		                    spaceships detect: [ :each | each = aTargetShip ] ].
	
	spaceshipInGame use: aCard targeting: aTargetCard affecting: aSpaceshipTarget in: self.
]

{ #category : 'behavior' }
Game >> playCard: aCard by: aSpaceship targeting: aTargetSpaceship [
    self play: aCard by: aSpaceship affecting: (NoEffectCard new)  targeting: aTargetSpaceship
]

{ #category : 'behavior' }
Game >> playTurn [
    | spaceshipToPlay positionsToAdvance |

    self checkIfGameHasAlreadyFinished.
    spaceshipToPlay := spaceships at: turnIndex.

    (spaceshipToPlay canPlay) ifTrue: [
        positionsToAdvance := self calculateTotalRollFor: spaceshipToPlay.
        spaceshipToPlay moveBy: positionsToAdvance on: board withLapLimit: lapsToWin.
        board handleLandingOf: spaceshipToPlay in: self.
        hasFinished := spaceshipToPlay hasReached: lapsToWin.
    ].

    turnIndex := turnIndex + 1.
    turnIndex > spaceships size ifTrue: [ turnIndex := 1 ].
    self endCycleIfNeeded.
]

{ #category : 'initialization' }
Game >> positionAfterMovingBack: positionsToGoBack for: aSpaceship [
	^ board positionAfterMovingBack: positionsToGoBack for: aSpaceship.
]

{ #category : 'behavior' }
Game >> registerAppliedEffect: anEffect [

	lastTileEffectApplied := anEffect
]

{ #category : 'accessing' }
Game >> registerLastCardPlayed: aCard [

    cardsThrown := aCard.
]

{ #category : 'behavior' }
Game >> registerThrownCard: aCard [

	cardsThrown := aCard
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
    turnIndex := turnIndex + 1.
    turnIndex > spaceships size ifTrue: [ turnIndex := 1 ].
    self endCycleIfNeeded.


]

{ #category : 'getter' }
Game >> spaceshipMatching: aSpaceship [

	^ (spaceships detect: [ :each | each = aSpaceship ]) deepCopy.
]

{ #category : 'behavior' }
Game >> spaceshipsExcept: aSpaceship do: aBlock [
	(spaceships reject: [ :each | each = aSpaceship ]) do: aBlock

]
