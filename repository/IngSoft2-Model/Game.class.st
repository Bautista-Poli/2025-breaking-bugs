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

{ #category : 'behavior' }
Game >> lastCardThrown [

	^ cardsThrown
]

{ #category : 'accessing' }
Game >> lastTileEffectApplied [

	^ lastTileEffectApplied
]

{ #category : 'behavior' }
Game >> makeAllSpaceShipsMoveAtHigherVelocity [

	spaceships do: [ :spaceship |
		spaceship moveAtHigherVelocity ]
]

{ #category : 'behavior' }
Game >> makeAllSpaceShipsMoveAtLowerVelocity [

	spaceships do: [ :spaceship |
		spaceship moveAtLowerVelocity ]
]

{ #category : 'behavior' }
Game >> playCard: aCard by: aSpaceship targeting: aTarget [
    "NUEVO"
    | spaceshipInGame targetInGame card |
    
    spaceshipInGame := spaceships detect: [ :each | each = aSpaceship ].
    
    targetInGame := aTarget 
        ifNil: [ nil ]
        ifNotNil: [ spaceships detect: [ :each | each = aTarget ] ifNone: [ nil ] ].
    

    (aCard canBePlayedBy: spaceshipInGame in: self)
        ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
    
    card := spaceshipInGame extractCardIfAvailable: aCard.
    card playBy: spaceshipInGame in: self targeting: targetInGame.
    
    ^ card
]

{ #category : 'behavior' }
Game >> playInstant: anInstantCard of: aSpaceship on: anotherCard [

	self
		playInstant: anInstantCard
		of: aSpaceship
		with: anotherCard 
		to: nil
]

{ #category : 'behavior' }
Game >> playInstant: aRepeatCard of: aSpaceship to: aTargetSpaceship [

	self
		playInstant: aRepeatCard
		of: aSpaceship
		with: NoEffectCard new
		to: aTargetSpaceship
]

{ #category : 'behavior' }
Game >> playInstant: anInstantCard of: aSpaceship with: aPermanentCard to: aTargetSpaceship [

	| realCard instantCard aSpaceshipInGame aTargetSpaceshipInGame |
	aSpaceshipInGame := spaceships detect: [ :each | each = aSpaceship ].
	aTargetSpaceshipInGame := spaceships
		                          detect: [ :each | each = aTargetSpaceship ]
		                          ifNone: [ nil ].
	instantCard := aSpaceshipInGame extractCardIfAvailable: anInstantCard.
	instantCard isInstant ifFalse: [ ^ nil ].
	realCard := activePermanentCards
		            detect: [ :each | each = aPermanentCard ]
		            ifNone: [
			            NoEffectCard new
			            "Error signal: 'The card wanted is not active'" ].
	instantCard
		implementEffect: realCard
		by: aSpaceshipInGame
		to: aTargetSpaceshipInGame
		in: self.
	activePermanentCards := activePermanentCards reject: [ :card |
		                        card == realCard ]
]

{ #category : 'behavior' }
Game >> playRound [

	self playRoundUsing: (NoEffectCard new) of: nil.
]

{ #category : 'behavior' }
Game >> playRoundSkipping: aSpaceshipCollection [ 

	self checkIfGameHasAlreadyFinished.
	(spaceships reject: [ :aSpaceship | aSpaceshipCollection includes: aSpaceship ])
	do: [ :aSpaceship |
		hasFinished ifFalse: [ 
			self playSpaceshipTurn: aSpaceship usingCard: (NoEffectCard new) against: nil ] ].

	(spaceships select: [ :aSpaceship | aSpaceshipCollection includes: aSpaceship ])
	do: [ :aSpaceship | aSpaceship rechargeShields ].


]

{ #category : 'behavior' }
Game >> playRoundUsing: aCard of: theSpaceship [

	self playRoundUsing: aCard of: theSpaceship to: nil.
]

{ #category : 'behavior' }
Game >> playRoundUsing: aCard of: theSpaceship to: targetSpaceship [
	self checkIfGameHasAlreadyFinished.
	1 to: spaceships size do: [ :i |
		self hasFinished ifFalse: [
			self playTurnUsing: aCard of: theSpaceship to: targetSpaceship
		]
	].


]

{ #category : 'behavior' }
Game >> playSpaceshipTurn: aSpaceship usingCard: aCard against: aTargetSpaceship [
    | positionsToAdvance card targetSpaceship |
    positionsToAdvance := self getAllDiceValuesFrom: dice.
    aSpaceship moveBy: positionsToAdvance on: board withLapLimit: lapsToWin.

    board handleLandingOf: aSpaceship in: self.

    hasFinished := aSpaceship hasReached: lapsToWin.
    
    targetSpaceship := self checkValid: aTargetSpaceship for: aSpaceship inCard: aCard.
    card := aCard checkIfEffectCanBeApplyToTarget: targetSpaceship.
    card := aSpaceship extractCardIfAvailable: card.
    
    card class = CancelationCard
        ifTrue: [ card implementEffect: activePermanentCards last by: aSpaceship to: aTargetSpaceship in: self ]
        ifFalse: [ card implementEfectBy: aSpaceship on: targetSpaceship in: self ].

    card isPermanent ifTrue: [ activePermanentCards add: card ].


]

{ #category : 'behavior' }
Game >> playTurnUsing: aCard of: theSpaceship to: targetSpaceship [
	| spaceshipToPlay cardToPlay |

	self checkIfGameHasAlreadyFinished.

	spaceshipToPlay := spaceships at: turnIndex.

	(spaceshipToPlay canPlay) ifTrue: [
		cardToPlay := (spaceshipToPlay = theSpaceship)
			ifTrue: [ aCard ]
			ifFalse: [ NoEffectCard new ].

		self hasFinished ifFalse: [
			self playSpaceshipTurn: spaceshipToPlay usingCard: cardToPlay against: targetSpaceship
		].
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
    "NUEVO"
    cardsThrown := aCard.
]

{ #category : 'behavior' }
Game >> registerPermanentCard: aCard ownedBy: aSpaceship [
    "NUEVO"
    activePermanentCards add: aCard.
]

{ #category : 'behavior' }
Game >> registerThrownCard: aCard [

	cardsThrown := aCard
]

{ #category : 'getter' }
Game >> spaceshipMatching: aSpaceship [

	^ (spaceships detect: [ :each | each = aSpaceship ]) deepCopy.
]

{ #category : 'behavior' }
Game >> spaceshipsExcept: aSpaceship do: aBlock [
	(spaceships reject: [ :each | each = aSpaceship ]) do: aBlock

]
