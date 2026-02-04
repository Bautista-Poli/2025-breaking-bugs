Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'aSize',
		'wormholeEntry',
		'wormholeExit',
		'tiles',
		'lapsToWin'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
Board class >> validate: aSize [

	aSize <= 0 ifTrue: [
		Error signal: 'The length of the board should be positive' ]
]

{ #category : 'validation' }
Board class >> validate: wormholeEntry and: wormholeExit within: aBoardDistance [
	
	((aBoardDistance lessThan: wormholeEntry) or: [ aBoardDistance lessThan: wormholeExit ]) ifTrue: [
        Error signal: 'The wormhole cannot be outside of the board' ]
]

{ #category : 'validation' }
Board class >> validate: wormholeEntry isLowerThan: wormholeExit [

	wormholeEntry >= wormholeExit ifTrue: [
		Error signal:
			'Wormhole entry position value has to be lower than the exit position value' ]
]

{ #category : 'validation' }
Board class >> validate: wormholeEntry notEqualTo: wormholeExit [

	wormholeEntry = wormholeExit ifTrue: [
		Error signal:
			'The entry and the exit of the wormhole cannot be at the same position' ]
]

{ #category : 'validation' }
Board class >> validateAreNotNegative: wormholeEntry and: wormholeExit [

	(wormholeEntry <= 0 or: wormholeExit <= 0) ifTrue: [
		Error signal: 'The wormhole cannot have negative entry or exit' ]
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit [
    ^ self 
        withSize: aSize
        andWormholeFrom: wormholeEntry
        to: wormholeExit
		  andLapsToWin: 1.
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit and: tiles [
	^ self withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: 1 and: tiles.
]

{ #category : 'creation' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: aLapsToWin [
    | tiles |
    tiles := (1 to: aSize + 1) collect: [ :i | Tile with: NoEffect new ].
    ^ self 
        withSizeDistance: (Parsec with: aSize)
        andWormholeFrom: wormholeEntry
        to: wormholeExit
		  andLapsToWin: aLapsToWin
        and: tiles
]

{ #category : 'creation' }
Board class >> withSize: aSize andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: aLapsToWin and: tiles [
    ^ self 
        withSizeDistance: (Parsec with: aSize)
        andWormholeFrom: wormholeEntry
        to: wormholeExit
		  andLapsToWin: aLapsToWin
        and: tiles   
]

{ #category : 'as yet unclassified' }
Board class >> withSizeDistance: aSizeDistance andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: aLapsToWin and: tiles [
    
    aSizeDistance validate.
    self validateAreNotNegative: wormholeEntry and: wormholeExit.
    self validate: wormholeEntry and: wormholeExit within: aSizeDistance.
    self validate: wormholeEntry notEqualTo: wormholeExit.
    self validate: wormholeEntry isLowerThan: wormholeExit.
    
    ^ self new
        initializeWith: tiles
        andSize: aSizeDistance
        andWormholeFrom: wormholeEntry
        to: wormholeExit
		  andLapsToWin: aLapsToWin
]

{ #category : 'as yet unclassified' }
Board class >> withSizeInLightYears: aSize andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: aLapsToWin [
    | tiles |
    tiles := (1 to: (aSize // 3) + 1) collect: [ :i | Tile with: NoEffect new ].
    
    ^ self 
        withSizeDistance: (LightYear with: aSize) 
        andWormholeFrom: wormholeEntry 
        to: wormholeExit 
		  andLapsToWin: aLapsToWin
        and: tiles
]

{ #category : 'as yet unclassified' }
Board class >> withSizeInLightYears: aSize andWormholeFrom: wormholeEntry to: wormholeExit andLapsToWin: aLapsToWin and: tiles [
 	|  sizeInParsecs  |

    sizeInParsecs := aSize // 3.

    ^ self 
        withSizeDistance: (LightYear with: aSize)
        andWormholeFrom: wormholeEntry   
        to: wormholeExit  
		  andLapsToWin: aLapsToWin                 
        and: tiles
]

{ #category : 'initialization' }
Board >> applyTileEffectTo: aSpaceship in: aGame [

	| position tile |
	position := aSpaceship getPosition.
	tile := tiles at: (position+1).
	tile applyEffectTo: aSpaceship in: aGame.
]

{ #category : 'as yet unclassified' }
Board >> checkSize: aDistanceToCompare [
	^ aSize checkIfEquals: aDistanceToCompare.
]

{ #category : 'testing' }
Board >> correctPositionAfterWormholeIfNeeded: aSpaceshipPosition [
	
	^ aSpaceshipPosition = wormholeEntry
		ifTrue: [ wormholeExit ]
		ifFalse: [
			aSpaceshipPosition = wormholeExit
				ifTrue: [ wormholeEntry ]
				ifFalse: [ aSpaceshipPosition ] ]
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

{ #category : 'testing' }
Board >> hasWormholeFrom: anEntry to: anExit [
    ^ (wormholeEntry = anEntry) 
        and: [ wormholeExit = anExit ]
	
]

{ #category : 'initialization' }
Board >> initializeWith: aTileCollection andSize: aDistanceSize andWormholeFrom: aWormholeEntry to: aWormholeExit andLapsToWin: aLapsToWin [

	aSize := aDistanceSize.
	tiles := aTileCollection.
	wormholeEntry := aWormholeEntry.
	wormholeExit := aWormholeExit.
	lapsToWin := aLapsToWin.
	
]
