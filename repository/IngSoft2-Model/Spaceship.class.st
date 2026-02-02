Class {
	#name : 'Spaceship',
	#superclass : 'Object',
	#instVars : [
		'position',
		'laps',
		'turnsPenalize',
		'cards',
		'mercenaries',
		'id',
		'owner',
		'shieldStatus'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Spaceship class >> new [

	| randomCardsCollection |
	randomCardsCollection := OrderedCollection
		               with: RandomCard obtainCard
		               with: RandomCard obtainCard.
	^ self basicNew initializeWith: randomCardsCollection.
]

{ #category : 'instance creation' }
Spaceship class >> with: cardsCollection [

	^ self basicNew initializeWith:cardsCollection.
]

{ #category : 'adding' }
Spaceship >> = anotherSpaceship [
	| boolean |
	anotherSpaceship ifNil: [ ^ false ].
	boolean := (id = anotherSpaceship getId).
	^ boolean.
	
]

{ #category : 'adding' }
Spaceship >> addNewCard: aCard [ 
    cards add: aCard.
	
]

{ #category : 'as yet unclassified' }
Spaceship >> adjustPositionAfterMoving: newPosition on: aBoard [
	 "NUEVO"
    | lapsCompleted positionInBoard aBoardSize |
	 aBoardSize := aBoard getSize.
    lapsCompleted := aBoardSize calculateLapsIn: newPosition.
    positionInBoard := aBoardSize calculatePositionIn: newPosition.
    
    self incrementLapsBy: lapsCompleted.
    
    ^ (aBoard hasSpaceshipFinished: self) 
        ifTrue: [ aBoardSize asParsec ]
        ifFalse: [ positionInBoard ]
]

{ #category : 'testing' }
Spaceship >> beMercenaryOf: anOwnerSpaceship [
	"NUEVO"

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
	| foundCard |
	"REVISAR"
    foundCard := cards detect: [ :each | each class = aCard class  ] ifNone: [ NoEffectCard new ].
    cards remove: foundCard ifAbsent: [].
    ^ foundCard
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
Spaceship >> getId [

	^ id.
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

{ #category : 'behavior' }
Spaceship >> incrementLapsBy: lapsIncremented [

	laps := laps + lapsIncremented
]

{ #category : 'initialization' }
Spaceship >> initializeWith: aCollectionOfCards [

	position := 0.
	laps := 0.
	shieldStatus := ShieldsActive withCount: 3.
	cards := aCollectionOfCards.
	mercenaries := OrderedCollection new.
	owner := false.
	id := 'Nave-' , (0 to: 9999) atRandom asString.
]

{ #category : 'adding' }
Spaceship >> isAheadOf: anotherSpaceship [
    (laps = anotherSpaceship getLapsCompleted)
        ifTrue: [ ^ position > anotherSpaceship getPosition ]
        ifFalse: [ ^ laps > anotherSpaceship getLapsCompleted ]
	
]

{ #category : 'adding' }
Spaceship >> isAtLap: aLap andAtSquare: aSquare [
    ^ (laps = aLap) and: [ position = aSquare ]
]

{ #category : 'testing' }
Spaceship >> isAtPosition: aPosition [

	^ position = aPosition
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

{ #category : 'behavior' }
Spaceship >> makeSpaceshipOwnedBy: aSpaceship [ 
	owner := true.

]

{ #category : 'getter' }
Spaceship >> moveBy: positionsToAdvance on: aBoard [
	 "NUEVO"
    | tentativePosition finalPosition |
    
    tentativePosition := position + positionsToAdvance.
    tentativePosition := aBoard correctPositionAfterWormholeIfNeeded: tentativePosition.
    finalPosition := self adjustPositionAfterMoving: tentativePosition 
                             on: aBoard.
    
    self moveToPosition: finalPosition.
	 ^ aBoard hasSpaceshipFinished: self.
]

{ #category : 'move' }
Spaceship >> moveToPosition: aPosition [

	aPosition negative ifTrue: [
		Error signal: 'The spaceship cannot move to a negative position' ].
	position := aPosition.
]

{ #category : 'getter' }
Spaceship >> numberOfMercenaries [

	^ mercenaries size
]

{ #category : 'behavior' }
Spaceship >> penalize [

	turnsPenalize := turnsPenalize + 1.
	turnsPenalize ~= 2 ifTrue: [ ^ self ].

	self rechargeShields.
	turnsPenalize := 0
]

{ #category : 'behavior' }
Spaceship >> rechargeShields [

	shieldStatus rechargeShieldsFor: self
]

{ #category : 'as yet unclassified' }
Spaceship >> use: aCard targeting: aTargetCard affecting: aTargetShip in: aGame [
    | cardToPlay |
    self validateIfCardIsInDeck: aCard.
    aCard canBePlayedBy: self in: aGame.
        
    cardToPlay := self extractCardIfAvailable: aCard.
    cardToPlay playBy: self in: aGame targeting: aTargetCard affecting: aTargetShip.
]

{ #category : 'behavior' }
Spaceship >> validateIfCardIsInDeck: aCard [
    (cards includes: aCard) ifFalse: [ 
        Error signal: 'Cant use a card that is not on the deck' 
    ].
]
