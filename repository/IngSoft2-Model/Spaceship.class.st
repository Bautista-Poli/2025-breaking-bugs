Class {
	#name : 'Spaceship',
	#superclass : 'Object',
	#instVars : [
		'position',
		'laps',
		'shields',
		'turnsPenalize',
		'cards',
		'velocity',
		'mercenaries',
		'id',
		'owner'
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
Spaceship >> adjustPositionAfterMoving: newPosition onBoardOfSize: aBoardSize withLapLimit: lapLimit [
    | lapsCompleted positionInBoard |
    lapsCompleted := aBoardSize calculateLapsIn: newPosition.
    positionInBoard := aBoardSize calculatePositionIn: newPosition.
    
    self incrementLapsBy: lapsCompleted.
    
    ^ (self hasReached: lapLimit)
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

	^ shields > 0
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

	^ shields
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
	shields := 3.
	turnsPenalize := -1.
	cards := aCollectionOfCards.
	velocity := 0.
	mercenaries := OrderedCollection new.
	owner := false.
	id := 'Nave-' , (0 to: 9999) atRandom asString
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

	shields > 0 ifTrue: [ shields := shields - 1 ]
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
Spaceship >> moveBy: positionsToAdvance on: aBoard withLapLimit: lapLimit [
    | tentativePosition finalPosition |
    
    tentativePosition := position + positionsToAdvance.
    tentativePosition := aBoard correctPositionAfterWormholeIfNeeded: tentativePosition.
    finalPosition := self adjustPositionAfterMoving: tentativePosition 
                             onBoardOfSize: aBoard getSize 
                             withLapLimit: lapLimit.
    
    self moveToPosition: finalPosition.
]

{ #category : 'move' }
Spaceship >> moveToPosition: aPosition [

	aPosition negative ifTrue: [
		Error signal: 'The spaceship cannot move to a negative position' ].
	position := aPosition + velocity
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

	shields := 3
]

{ #category : 'behavior' }
Spaceship >> validateIfCardIsInDeck: aCard [
    (cards includes: aCard) ifFalse: [ 
        Error signal: 'Cant use a card that is not on the deck' 
    ].
]
