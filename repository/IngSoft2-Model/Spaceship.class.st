Class {
	#name : 'Spaceship',
	#superclass : 'Object',
	#instVars : [
		'position',
		'laps',
		'cards',
		'mercenaries',
		'id',
		'owner',
		'shieldStatus',
		'jailStatus'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Spaceship class >> new [
	self error: 'Debe ser inicializado con un id'
]

{ #category : 'instance creation' }
Spaceship class >> with: anId [

	| randomCardsCollection |
	randomCardsCollection := OrderedCollection
		               with: RandomCard obtainCard
		               with: RandomCard obtainCard.
	^ self basicNew initializeWith: randomCardsCollection and: anId.
]

{ #category : 'instance creation' }
Spaceship class >> with: cardsCollection and: anId [

	^ self basicNew initializeWith:cardsCollection and: anId.
]

{ #category : 'adding' }
Spaceship >> addNewCard: aCard [ 
    cards add: aCard.
	
]

{ #category : 'initialization' }
Spaceship >> applyPenality [
	position := 0.
	shieldStatus lowerShieldFor: self
]

{ #category : 'testing' }
Spaceship >> beMercenaryOf: anOwnerSpaceship [

	self hasOwner ifTrue: [
		Error signal: 'A mercenary cannot hire other spaceships' ].
	owner := true.
	anOwnerSpaceship makeHimOwnerOf: self
]

{ #category : 'behavior' }
Spaceship >> canPlay [

	^ shieldStatus canPlay
]

{ #category : 'behavior' }
Spaceship >> changeShieldStatusTo: aNewShieldStatus [
    shieldStatus := aNewShieldStatus
]

{ #category : 'behavior' }
Spaceship >> extractCardIfAvailable: aCard [
    | cardToPlay |
    cardToPlay := cards 
        detect: [ :each | each class = aCard ] 
        ifNone: [ Error signal: 'Cant use a card that is not on the deck' ].
    
    cards remove: cardToPlay.
    ^ cardToPlay
]

{ #category : 'behavior' }
Spaceship >> fire: aSpaceship [ 
	mercenaries remove: aSpaceship ifAbsent: [].
]

{ #category : 'getter' }
Spaceship >> getCards [

	^ cards
]

{ #category : 'getter' }
Spaceship >> getLapsCompleted [

	^ laps
]

{ #category : 'getter' }
Spaceship >> getMercenaries [
	^ mercenaries.
]

{ #category : 'testing' }
Spaceship >> getPosition [

	^ position
]

{ #category : 'getter' }
Spaceship >> getShields [

	^ shieldStatus shieldCount
]

{ #category : 'as yet unclassified' }
Spaceship >> handleEndOfCycle [
	shieldStatus handleEndOfCycleFor: self
]

{ #category : 'as yet unclassified' }
Spaceship >> handleRoll: aRoll in: aGame [ 
	jailStatus handleRoll: aRoll for: self in: aGame.
]

{ #category : 'testing' }
Spaceship >> hasHimAsMercenary: aSpaceship [ 
	^ mercenaries includes: aSpaceship.
]

{ #category : 'testing' }
Spaceship >> hasOwner [
	^ owner.
]

{ #category : 'behavior' }
Spaceship >> hasReached: lapsToWin [

	^ laps >= lapsToWin
]

{ #category : 'adding' }
Spaceship >> hasSameIdAs: anotherSpaceship [

	^ anotherSpaceship matchesId: id
]

{ #category : 'initialization' }
Spaceship >> initializeWith: aCollectionOfCards and: anId [

	position := 0.
	laps := 0.
	shieldStatus := ShieldsActive withCount: 3.
	cards := aCollectionOfCards.
	mercenaries := OrderedCollection new.
	owner := false.
	id:= anId.
	jailStatus := FreeFromJail new.
]

{ #category : 'testing' }
Spaceship >> isAheadOf: aSpaceship inBoard: aBoardSize [ 
	^ aSpaceship isBehind: position+(laps*aBoardSize asParsec) in: aBoardSize.
]

{ #category : 'adding' }
Spaceship >> isAtLap: aLap andAtSquare: aSquare [
    ^ (laps = aLap) and: [ position = aSquare ]
]

{ #category : 'testing' }
Spaceship >> isAtPosition: aPosition [

	^ position = aPosition
]

{ #category : 'testing' }
Spaceship >> isBehind: anotherPosition in: aBoardSize [ 
	^ position+(laps*aBoardSize asParsec) < anotherPosition
]

{ #category : 'testing' }
Spaceship >> isInJail [
	^ jailStatus isInJail
]

{ #category : 'behavior' }
Spaceship >> lowerAShield [

	shieldStatus lowerShieldFor: self
]

{ #category : 'behavior' }
Spaceship >> makeHimOwnerOf: aMercenarySpaceship [ 
    self hasOwner ifTrue: [ Error signal: 'A mercenary cannot hire other spaceships' ].
    mercenaries add: aMercenarySpaceship.

]

{ #category : 'testing' }
Spaceship >> matchesId: anId [ 
	^ id = anId.
]

{ #category : 'move' }
Spaceship >> moveToPosition: aPosition [

	aPosition negative ifTrue: [
		Error signal: 'The spaceship cannot move to a negative position' ].
	position := aPosition.
]

{ #category : 'behavior' }
Spaceship >> rechargeShields [

	shieldStatus rechargeShieldsFor: self
]

{ #category : 'as yet unclassified' }
Spaceship >> releaseFromJail [
	jailStatus := FreeFromJail new.
]

{ #category : 'behavior' }
Spaceship >> releaseFromOwner [ 
    owner := false.
]

{ #category : 'as yet unclassified' }
Spaceship >> rollBestValueUsing: dicesCollection [ 
    | best roll |
    best := dicesCollection inject: 0 into: [ :sum :aDie | sum + aDie roll ].
    mercenaries size timesRepeat: [
        roll := dicesCollection inject: 0 into: [ :sum :aDie | sum + aDie roll ].
        best := roll max: best.
    ].
    ^ best
]

{ #category : 'as yet unclassified' }
Spaceship >> sendToJail [
    jailStatus := InJail new.
]

{ #category : 'behavior' }
Spaceship >> setLapsTo: lapsIncremented [

	laps := lapsIncremented
]

{ #category : 'as yet unclassified' }
Spaceship >> use: aCardClass targeting: aTargetCard affecting: aTargetShip in: aGame [
    | cardToPlay |
    self validateHasCardOfType: aCardClass.
    aCardClass canBePlayedBy: self in: aGame.
        
    cardToPlay := self extractCardIfAvailable: aCardClass.
    cardToPlay playBy: self in: aGame targeting: aTargetCard affecting: aTargetShip.
]

{ #category : 'as yet unclassified' }
Spaceship >> validateHasCardOfType: aCardClass [
    (cards anySatisfy: [ :c | c class = aCardClass ]) ifFalse: [
        Error signal: 'Cant use a card that is not on the deck'
    ].

]
