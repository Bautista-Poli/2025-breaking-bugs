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

{ #category : 'adding' }
Spaceship >> hasSameIdAs: anotherSpaceship [

	^ anotherSpaceship matches: id
]

{ #category : 'behavior' }
Spaceship >> incrementLapsBy: lapsIncremented [

	laps := laps + lapsIncremented
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

{ #category : 'testing' }
Spaceship >> matches: anId [ 
	^ id = anId.
]

{ #category : 'testing' }
Spaceship >> moveBackBy: positions on: aBoard [
    | boardSize tentativePosition lapsChange |
    
    boardSize := aBoard getSize asParsec.
    tentativePosition := position - positions.
    lapsChange := 0.
    

    [ tentativePosition < 0 and: [ laps + lapsChange > 0 ] ] whileTrue: [
        lapsChange := lapsChange - 1.
        tentativePosition := tentativePosition + boardSize.
    ].
    
    "Si llegamos antes del inicio, resetear a 0,0"
    (tentativePosition < 0 or: [ laps + lapsChange < 0 ])
        ifTrue: [ 
            self moveToPosition: 0.
            self incrementLapsBy: (0 - laps). "Resetear laps a 0"
        ]
        ifFalse: [
            self moveToPosition: tentativePosition.
            self incrementLapsBy: lapsChange.
        ].
]

{ #category : 'getter' }
Spaceship >> moveBy: positionsToAdvance on: aBoard [
	| tentativePosition aBoardSize lapsCompleted positionInBoard finalPosition |

	tentativePosition := position + positionsToAdvance.
	tentativePosition := aBoard correctPositionAfterWormholeIfNeeded: tentativePosition.

	aBoardSize := aBoard getSize.
	lapsCompleted := aBoardSize calculateLapsIn: tentativePosition.
	positionInBoard := aBoardSize calculatePositionIn: tentativePosition.

	self incrementLapsBy: lapsCompleted.

	finalPosition := (aBoard hasSpaceshipFinished: self)
		ifTrue: [ aBoardSize asParsec ]
		ifFalse: [ positionInBoard ].

	self moveToPosition: finalPosition.

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
