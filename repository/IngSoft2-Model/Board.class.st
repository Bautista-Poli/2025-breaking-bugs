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
	^ self new
        initializeWith: tiles
        andSize: aSize
		  andLapsToWin: 1.
]

{ #category : 'creation' }
Board class >> withSize: aSize andLapsToWin: aLapsToWin and: tiles [
	 | aParsec |
	 aParsec := (Parsec with: aSize).
    ^ self new
        initializeWith: tiles
        andSize: aParsec
		  andLapsToWin: aLapsToWin.   
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit [
	  | tiles parsec |
	 parsec := (Parsec with: aSize).
	 parsec validate.
    tiles := (TilesBuilder with: aSize) addWormholeFrom: wormholeEntry to: wormholeExit; build.
    ^ self new
        initializeWith: tiles
        andSize: parsec
		  andLapsToWin: 1.
]

{ #category : 'as yet unclassified' }
Board >> checkSize: aDistanceToCompare [
	^ aSize asParsec = aDistanceToCompare asParsec.
]

{ #category : 'behavior' }
Board >> createPositionTable: spaceships [
	^ PositionTable with: spaceships boardSize: aSize.
]

{ #category : 'initialization' }
Board >> handleLandingOf: aSpaceship in: aGame [
    | tile |
    tile := tiles at: (aSpaceship position square + 1).
    tile handleArrivalOf: aSpaceship in: aGame.
]

{ #category : 'testing' }
Board >> hasAnySpaceshipFinished: aCollectionOfSpaceships [
    ^ aCollectionOfSpaceships anySatisfy: [ :each | each hasReached: lapsToWin ].
]

{ #category : 'initialization' }
Board >> initializeWith: aTileCollection andSize: aDistanceSize andLapsToWin: aLapsToWin [

	aSize := aDistanceSize.
	tiles := aTileCollection.
	lapsToWin := aLapsToWin.
	
]

{ #category : 'testing' }
Board >> move: aSpaceship by: positionsToAdvance [
    aSpaceship advancedBy: positionsToAdvance withBoardSize: aSize asParsec and: lapsToWin.


	
]

{ #category : 'testing' }
Board >> tilesToMoveForDistance: aDistance [
	| aDistribution |
	aDistribution := (aSize asParsec / tiles size) ceiling.
	^ aDistance asParsec // aDistribution.
	
]
