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
		'activatedAtomicBomb',
		'cardsThrown',
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
    "Nuevo"
    ^ activePermanentCards
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
Game >> lastActivePermanentCard [

	^ activePermanentCards removeLast
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
    "NUEVO"
    | spaceshipInGame aSpaceshipTarget card aCardTarget |
    
    spaceshipInGame := spaceships detect: [ :each | each = aSpaceship ].
    
    aSpaceshipTarget := aTargetShip 
        ifNil: [ nil ]
        ifNotNil: [ spaceships detect: [ :each | each = aTargetShip ] ifNone: [ nil ] ].
	
	aCardTarget := activePermanentCards 
        detect: [ :each | each = aTargetCard ] 
        ifNone: [ Error signal: 'Cannot cancel a card that is not active' ].
    
	spaceshipInGame validateIfCardIsInDeck: aCard.
    (aCard canBePlayedBy: spaceshipInGame in: self)
        ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
    
    card := spaceshipInGame extractCardIfAvailable: aCard.
    card playBy: spaceshipInGame in: self targeting: aCardTarget affecting: aSpaceshipTarget.
    
    ^ card
]

{ #category : 'behavior' }
Game >> playCard: aCard by: aSpaceship targeting: aTargetSpaceship [
    "NUEVO"
    | spaceshipInGame aSpaceshipTarget card |
    
    spaceshipInGame := spaceships detect: [ :each | each = aSpaceship ].
    
    aSpaceshipTarget := aTargetSpaceship 
        ifNil: [ nil ]
        ifNotNil: [ spaceships detect: [ :each | each = aTargetSpaceship ] ifNone: [ nil ] ].
    
	spaceshipInGame validateIfCardIsInDeck: aCard.
    (aCard canBePlayedBy: spaceshipInGame in: self)
        ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
    
    card := spaceshipInGame extractCardIfAvailable: aCard.
    card playBy: spaceshipInGame in: self targeting: (NoEffectCard new) affecting: aSpaceshipTarget.
]

{ #category : 'behavior' }
Game >> playRound [

	self playRoundUsing: (NoEffectCard new) of: nil to:nil.
]

{ #category : 'behavior' }
Game >> playRoundUsing: aCard of: theSpaceship to: targetSpaceship [
	self checkIfGameHasAlreadyFinished.
	1 to: spaceships size do: [ :i |
		self hasFinished ifFalse: [
			self playTurn
		]
	].


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
