Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
BoardTest >> should: test raise: aErrorClass withMessageError: aMessage [ 
	self 
		should: test
		raise: aErrorClass 
		withExceptionDo:  [: error | self assert: (error messageText) equals: aMessage].
]

{ #category : 'tests' }
BoardTest >> testCreatingABoardWithSizeInLightYearsAndWormhole [
    | aBoard aGame aSpaceship dice tileBuilder aGameBuilder id1 |

    tileBuilder := TilesBuilder withLighyears: (LightYear with: 60). 
    
    tileBuilder addWormholeFrom: 4 to: 15.
    
    
	 aBoard := Board withDistance: (LightYear with: 60) andLapsToWin: 2 and: (tileBuilder build).
    
    id1 := 'nave'.
    aSpaceship := Spaceship with: id1.
    
    dice := FixedDice onFace: 4. 
    
    aGameBuilder := GameBuilder new. 
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: aBoard;
        addDice: dice;
        build. 

    aGame playTurn. 

    self assert: (aBoard checkSize: (Parsec with: 20)).
    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 15.
]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByOneAfterPassingBoardLimit [

	| aGameBuilder aSpaceship aGame anId|
	"board con laps 2"
	aGameBuilder := GameBuilder new.
	anId := 'nave1'.
	aSpaceship := Spaceship with: anId.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 25);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: anId) getLapsCompleted equals: 1.
	
]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByOneAfterPassingBoardLimitwithTwoSpaceships [
	
	| aGameBuilder aSpaceship aGame anId |
	aGameBuilder := GameBuilder new.
	anId := 'nave1'.
	aSpaceship := Spaceship with: anId.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: (Spaceship with: 'nave2');
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 22); "Si es 20 da error"
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: anId) getLapsCompleted equals: 1.

]

{ #category : 'tests' }
BoardTest >> testLapsIncrementByTwoWhenPassingBoardTwice [
	
	| aGameBuilder aSpaceship aGame anId |
	"ESTA MAL ESTE TEST"
	aGameBuilder := GameBuilder new.
	anId := 'nave1'.
	aSpaceship := Spaceship with: anId.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 40);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: anId) getLapsCompleted equals: 2.


]

{ #category : 'tests' }
BoardTest >> testPositionResetsAfterPassingBoardLimit [
	
	| aGameBuilder aSpaceship aGame anId builder tiles|
	aGameBuilder := GameBuilder new.
	anId := 'nave1'.
	aSpaceship := Spaceship with: anId.
	 builder := TilesBuilder with: 20.
    builder addWormholeFrom: 4 to: 9.
 	tiles := builder build.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andLapsToWin: 2 and: tiles);
		         addDice: (FixedDice onFace: 25);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: anId) getPosition equals: 5.

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
