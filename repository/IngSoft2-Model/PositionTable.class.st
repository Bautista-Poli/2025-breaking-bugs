Class {
	#name : 'PositionTable',
	#superclass : 'Object',
	#instVars : [
		'spaceships',
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
        s1 isAheadOf: s2 inBoard: boardSize asParsec ]
]

{ #category : 'initialization' }
PositionTable >> instanceWith: aCollectionOfSpaceships boardSize: aBoardSize [
    spaceships := aCollectionOfSpaceships collect: [ :each | each deepCopy ].
    boardSize := aBoardSize.
]

{ #category : 'behavior' }
PositionTable >> isShipWithId: anId atLap: aLap andSquare: aSquare [
    | foundShip |
    foundShip := spaceships 
        detect: [ :each | each matchesId: anId ] 
        ifNone: [ ^ false ].
    ^ foundShip isAt: aSquare and: aLap.
]

{ #category : 'behavior' }
PositionTable >> isWinner: anId [
    ^ (self getRanking first) matchesId: anId.
]
