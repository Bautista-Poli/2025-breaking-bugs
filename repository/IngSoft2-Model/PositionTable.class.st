Class {
	#name : 'PositionTable',
	#superclass : 'Object',
	#instVars : [
		'spaceships',
		'winner',
		'boardSize'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
PositionTable class >> with: spaceships boardSize: aBoardSize [
    ^ self new instanceWith: spaceships boardSize: aBoardSize
]

{ #category : 'behavior' }
PositionTable >> getRanking [
    ^ spaceships asSortedCollection: [ :s1 :s2 | 
        s1 isAheadOf: s2 inBoard: boardSize ]
]

{ #category : 'initialization' }
PositionTable >> instanceWith: aCollectionOfSpaceships [

	spaceships := aCollectionOfSpaceships collect: [ :each | each copy ].
]

{ #category : 'initialization' }
PositionTable >> instanceWith: aCollectionOfSpaceships boardSize: aBoardSize [
    spaceships := aCollectionOfSpaceships collect: [ :each | each copy ].
    boardSize := aBoardSize.
]

{ #category : 'behavior' }
PositionTable >> isShipWithId: anId atLap: aLap andSquare: aSquare [
    | foundShip |
    foundShip := spaceships 
        detect: [ :each | each matchesId: anId ] 
        ifNone: [ ^ false ].
    ^ foundShip isAtLap: aLap andAtSquare: aSquare.
]

{ #category : 'behavior' }
PositionTable >> isWinner: anId [
    ^ (self getRanking first) matchesId: anId.
]
