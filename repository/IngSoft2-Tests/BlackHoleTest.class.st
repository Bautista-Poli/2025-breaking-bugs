Class {
	#name : 'BlackHoleTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BlackHoleTest >> testWhenSpaceshipLandsOnBlackHoleItMovesBack4PositionsWithoutTriggeringBattle [

	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (BlackHoleEffect new) at: 9.
	aTileBuilder with: (BlackHoleEffect new) at: 13.
	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andWormholeFrom: 10 to: 15 and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: 'nave2');
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #( 13 9 ));
		         build.
	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: 'nave1') getPosition equals: 5.
]

{ #category : 'tests' }
BlackHoleTest >> testWhenSpaceshipLandsOnBlackHoleThenItIsMovedBack4Positions [

	| aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	
	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (BlackHoleEffect new) at: 4.
	aTileCollection := aTileBuilder build.
	aBoard := (Board withSize: finishLine andWormholeFrom: 5 to: 15 and: aTileCollection).
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
			      addBoard: aBoard;   
		         addDice: (FixedDice onFace: 4);
		         build.
	aGame playTurn.
	
	self assert: (aSpaceship isAtPosition:0).

]
