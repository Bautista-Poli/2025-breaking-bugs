Class {
	#name : 'TurnManager',
	#superclass : 'Object',
	#instVars : [
		'spaceships',
		'turnIndex'
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

{ #category : 'initialization' }
TurnManager >> initializeWith: aCollectionOfSpaceships [
    spaceships := aCollectionOfSpaceships.
    turnIndex := 1.
]

{ #category : 'initialization' }
TurnManager >> isCurrentTurnOf: aSpaceship [
    ^ self currentSpaceship == aSpaceship.
]

{ #category : 'initialization' }
TurnManager >> nextTurn [
    turnIndex := (turnIndex \\ spaceships size) + 1.
]
