Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'aSize',
		'tiles',
		'lapsToWin'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Board class >> withDistance: aSizeDistance andLapsToWin: aLapsToWin and: tiles [
    
    ^ self new
        initializeWith: tiles
        andSize: aSizeDistance
		  andLapsToWin: aLapsToWin.
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aSize and: tiles [
	^ self withSize: aSize andLapsToWin: 1 and: tiles.
]

{ #category : 'creation' }
Board class >> withSize: aSize andLapsToWin: aLapsToWin and: tiles [
	 | aParsec |
	 aParsec := (Parsec with: aSize).
    ^ self 
        withDistance: aParsec
		  andLapsToWin: aLapsToWin
        and: tiles   
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit [
	  | builder tiles parsec |
	 parsec := (Parsec with: aSize).
	 parsec validate.
	 builder := TilesBuilder with: aSize.
    builder addWormholeFrom: wormholeEntry to: wormholeExit.
    tiles := builder build.
    ^ self 
        withDistance: parsec
		  andLapsToWin: 1
        and: tiles.   
]

{ #category : 'as yet unclassified' }
Board >> checkSize: aDistanceToCompare [
	^ aSize asParsec = aDistanceToCompare asParsec.
]

{ #category : 'behavior' }
Board >> createPositionTable: spaceships [
	^ PositionTable with: spaceships.
]

{ #category : 'initialization' }
Board >> getSize [

	^ aSize.
]

{ #category : 'initialization' }
Board >> handleLandingOf: aSpaceship in: aGame [
    | tile |
    tile := tiles at: (aSpaceship getPosition + 1).
    tile handleArrivalOf: aSpaceship in: aGame.
]

{ #category : 'testing' }
Board >> hasAnySpaceshipFinished: aCollectionOfSpaceships [
    ^ aCollectionOfSpaceships anySatisfy: [ :each | self hasSpaceshipFinished: each ].
]

{ #category : 'testing' }
Board >> hasSpaceshipFinished: aSpaceship [ 
	^ aSpaceship hasReached: lapsToWin
]

{ #category : 'initialization' }
Board >> initializeWith: aTileCollection andSize: aDistanceSize andLapsToWin: aLapsToWin [

	aSize := aDistanceSize.
	tiles := aTileCollection.
	lapsToWin := aLapsToWin.
	
]

{ #category : 'testing' }
Board >> move: aSpaceship by: positionsToAdvance [
    | absolutePosition newAbsolutePosition newLap newPosition |
    
    absolutePosition := (aSpaceship getLapsCompleted * aSize asParsec) + aSpaceship getPosition.
    
    newAbsolutePosition := absolutePosition + positionsToAdvance.
    
    newAbsolutePosition := newAbsolutePosition max: 0.
    
    newLap := newAbsolutePosition // aSize asParsec.
    newPosition := newAbsolutePosition \\ aSize asParsec.

    aSpaceship incrementLapsBy: newLap.
    
    (self hasSpaceshipFinished: aSpaceship)
        ifTrue: [ aSpaceship moveToPosition: aSize asParsec ]
        ifFalse: [ aSpaceship moveToPosition: newPosition ].
	
]
