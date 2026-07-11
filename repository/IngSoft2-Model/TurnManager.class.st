Class {
	#name : 'TurnManager',
	#superclass : 'Object',
	#instVars : [
		'spaceships',
		'turnIndex',
		'fowardDirection'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
TurnManager class >> with: aCollection [ 
	^ self new initializeWith: aCollection.
]

{ #category : 'initialization' }
TurnManager >> currentSpaceship [
    ^ spaceships at: turnIndex.
]

{ #category : 'as yet unclassified' }
TurnManager >> endTurn [
	self currentSpaceship handleEndOfCycle.
	self nextTurn.
]

{ #category : 'initialization' }
TurnManager >> initializeWith: aCollectionOfSpaceships [
    spaceships := aCollectionOfSpaceships.
    turnIndex := 1.
	 fowardDirection := 1.
]

{ #category : 'initialization' }
TurnManager >> isCurrentTurnOf: aSpaceship [
    ^ self currentSpaceship == aSpaceship.
]

{ #category : 'initialization' }
TurnManager >> nextTurn [

	turnIndex := (turnIndex + fowardDirection - 1 \\ spaceships size) + 1.
]

{ #category : 'as yet unclassified' }
TurnManager >> reverseOrder [
	fowardDirection := 0-fowardDirection.
	turnIndex := spaceships size - turnIndex + 1.
]
