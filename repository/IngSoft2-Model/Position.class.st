Class {
	#name : 'Position',
	#superclass : 'Object',
	#instVars : [
		'square',
		'laps'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
Position class >> at: aSquare lap: aLap [
    ^ self new initializeAt: aSquare lap: aLap.
]

{ #category : 'accessing' }
Position class >> start [
    ^ self at: 0 lap: 0
]

{ #category : 'as yet unclassified' }
Position >> advancedBy: delta boardSize: boardSize and: lapsToWin [
    | absolute newLap newSquare |
    absolute := (laps * boardSize) + square + delta.
    absolute := absolute max: 0.
    newLap   := absolute // boardSize.
    newSquare := absolute \\ boardSize.

	^ self class at: newSquare lap: newLap.
]

{ #category : 'testing' }
Position >> hasReached: lapsToWin [ 
	^ laps >= lapsToWin.
]

{ #category : 'accessing' }
Position >> initializeAt: aSquare lap: aLap [
    square := aSquare.
    laps := aLap.
]

{ #category : 'accessing' }
Position >> isAt: aSquare and: aLap [ 
	^ (aSquare == square) and: (aLap == laps).
]

{ #category : 'testing' }
Position >> isEqualAs: aPosition [ 
	^ aPosition isAt: square and: laps.
]

{ #category : 'testing' }
Position >> isHigherThanScore: aNumberPosition in: aBoardSize [ 
	| myTotal |
	myTotal := square + ( laps * aBoardSize).
    ^ myTotal > aNumberPosition.
]

{ #category : 'testing' }
Position >> isLowerThan: aPosition in: boardSize [ 
    | myTotal |
    
    myTotal := square + ( laps * boardSize).
    ^ aPosition isHigherThanScore: myTotal in: boardSize.
]

{ #category : 'as yet unclassified' }
Position >> lap [
	^ laps.
]

{ #category : 'as yet unclassified' }
Position >> returnToStart [
	^ self class at: 0 lap: laps.
]

{ #category : 'accessing' }
Position >> square [
	^ square
]
