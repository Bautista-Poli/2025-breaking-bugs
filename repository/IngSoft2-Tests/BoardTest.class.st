Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#instVars : [
		'gameBuilder',
		'id1',
		'id2',
		'aSpaceship'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
BoardTest >> setUp [
	super setUp.

	gameBuilder := GameBuilder new.
	id1 := 'nave1'. 
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	gameBuilder addSpaceship: aSpaceship.
]

{ #category : 'asserting' }
BoardTest >> should: test raise: aErrorClass withMessageError: aMessage [ 
	self 
		should: test
		raise: aErrorClass 
		withExceptionDo:  [: error | self assert: (error messageText) equals: aMessage].
]

{ #category : 'tests' }
BoardTest >> testCreatingABoardWithSizeInLightYearsAndWormhole [
    | aBoard aGame dice tileBuilder |

    tileBuilder := TilesBuilder withLighyears: (LightYear with: 60). 
    tileBuilder addWormholeFrom: 4 to: 15.
    aBoard := Board withDistance: (LightYear with: 60) andLapsToWin: 2 and: (tileBuilder build).
    
    dice := FixedDice onFace: 4. 

    aGame := gameBuilder
        addBoard: aBoard;
        addDice: dice;
        build. 

    aGame playTurn. 

    self assert: (aBoard checkSize: (Parsec with: 20)).
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 15 and: 0).
]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByOneAfterPassingBoardLimit [

	| aGame|
	aGame := gameBuilder
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 25);
		         build.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 1).
	
]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByOneAfterPassingBoardLimitwithTwoSpaceships [
	
	|  aGame |
	aGame := gameBuilder
		         addSpaceship: (Spaceship with:id2 );
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 22); "Si es 20 da error"
		         build.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 2 and: 1).

]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByTwoWhenPassingBoardTwice [
	| aGame |
	aGame := gameBuilder
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 40);
		         build.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 2).


]

{ #category : 'tests' }
BoardTest >> testPositionResetsAfterPassingBoardLimit [
	
	| aGame  builder tiles|
	
	builder := TilesBuilder with: 20.
	builder addWormholeFrom: 4 to: 9.
	tiles := builder build.

	aGame := gameBuilder
		          addBoard: (Board withSize: 20 andLapsToWin: 2 and: tiles);
		          addDice: (FixedDice onFace: 25);
		          build.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 1).

]

{ #category : 'tests' }
BoardTest >> testWhenCreatingABoardWithSize20ThenSizeIs20 [

	| aBoard aSize |
	aSize := 20.
	aBoard := Board withSize: aSize andWormholeFrom: 4 to: 9.
	self assert: (aBoard checkSize: (Parsec with: aSize))
]

{ #category : 'tests' }
BoardTest >> testWhenSizeIsNegativeThenTheCreationOfTheBoardFails [

	| aSize |
	aSize:= -30.
	self should: [Board withSize: aSize andWormholeFrom: 4 to: 9]
		  raise: Error
		  withMessageError: 'The length of the board should be positive'.
]

{ #category : 'tests' }
BoardTest >> testWhenTryingToCreateABoardWithAWormholeWithSameEntryAndExitThenCreationFails [

	| aSize |
	aSize := 20.

	self
		should: [ Board withSize: aSize andWormholeFrom: 15 to: 15 ]
		raise: Error
		withMessageError: 'The entry and the exit of the wormhole cannot be at the same position'
]

{ #category : 'tests' }
BoardTest >> testWhenTryingToCreateAWormholeOutsideTheBoardThenCreationFails [

	| aSize |
	aSize := 20.

	self
		should: [ Board withSize: aSize andWormholeFrom: 15 to: 21 ]
		raise: Error
		withMessageError: 'The wormhole cannot be outside of the board'
]

{ #category : 'tests' }
BoardTest >> testWhenTryingToCreateAWormholeWithNegativeEntryThenCreationFails [

	| aSize |
	aSize := 20.

	self
		should: [ Board withSize: aSize andWormholeFrom: -5 to: 4 ]
		raise: Error
		withMessageError: 'The wormhole cannot have negative entry or exit'. 
]
