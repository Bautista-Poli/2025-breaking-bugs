Class {
	#name : 'MoonWalkTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
MoonWalkTest >> testMoonWalkCannotMoveSpaceshipToNegativeLaps [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	finishLine := 10.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (MoonWalkEffect for: 20) at: 6.
	aTileBuilder addWormholeFrom: 5 to: 9.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 3
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(15 6));
		         build.

	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id1) getLapsCompleted equals: 0.

]

{ #category : 'tests' }
MoonWalkTest >> testMoonWalkDoesNotMoveSpaceshipBelowStartWhenInFirstLap [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	finishLine := 20.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (MoonWalkEffect for: 6) at: 4.
	aTileBuilder addWormholeFrom: 5 to: 9.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: finishLine
					 andLapsToWin: 1
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(2 4));
		         build.

	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getLapsCompleted equals: 0.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 4.

]

{ #category : 'tests' }
MoonWalkTest >> testWhenMoonWalkPushesSpaceshipBackPastZeroThenItWrapsToPreviousLap [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	finishLine := 20.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (MoonWalkEffect for: 6) at: 4.
	aTileBuilder addWormholeFrom: 6 to: 9.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 2 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(25 24));
		         build.

	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 4.
	self assert: (aGame spaceshipMatchWith: id1) getLapsCompleted equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getLapsCompleted equals: 1.

	
]

{ #category : 'tests' }
MoonWalkTest >> testWhenSpaceshipLandsOnMoonWalkThenOtherSpaceshipMovesBack [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	finishLine := 20.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (MoonWalkEffect for: 2) at: 6.
	aTileBuilder addWormholeFrom: 15 to: 17.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 2
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(2 9 4 4));
		         build.

	aGame playTurn. aGame playTurn.
	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 6.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 11.

]
