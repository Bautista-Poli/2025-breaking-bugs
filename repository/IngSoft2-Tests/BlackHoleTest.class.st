Class {
	#name : 'BlackHoleTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BlackHoleTest >> testWhenBlackHoleMovesShipOntoOccupiedTileThenTheyBattle [
	| aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection ship1 ship2 id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	ship1 := Spaceship with: id1.
	ship2 := Spaceship with: id2.

	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: BlackHoleEffect new at: 5.
	aTileBuilder addWormholeFrom: 10 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: ship1;
		addSpaceship: ship2;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(1 5 1 6));
		build.

	aGame playTurn.aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 1 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) getShields) equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) getShields) equals: 2.
	


]

{ #category : 'tests' }
BlackHoleTest >> testWhenSpaceshipLandsOnBlackHoleInFirstPositionsThenItDoesNotGoBelowStart [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	finishLine := 19.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (BlackHoleEffect new) at: 2.
	aTileBuilder addWormholeFrom: 10 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #( 2 ));
		         build.

	aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: 'nave1') isAt: 0 and: 0).
]

{ #category : 'tests' }
BlackHoleTest >> testWhenSpaceshipLandsOnBlackHoleItMovesBack4PositionsWithoutTriggeringBattle [

	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (BlackHoleEffect new) at: 9.
	aTileBuilder with: (BlackHoleEffect new) at: 13.
	aTileBuilder addWormholeFrom: 10 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
	aGame := aGameBuilder
		          addSpaceship: (Spaceship with: 'nave2');
		          addSpaceship: aSpaceship;
		          addBoard: aBoard;
		          addDice: (SequentialFixedDice onFaces: #( 13 9 ));
		          build.
	
	aGame playTurn. 
	aGame playTurn. 

	self assert: ((aGame spaceshipMatchWith: 'nave1') isAt: 5 and: 0).
]

{ #category : 'tests' }
BlackHoleTest >> testWhenSpaceshipLandsOnBlackHoleThenItIsMovedBack4Positions [

	| aSpaceship aGameBuilder finishLine aGame id1 aBoard aTileCollection aTileBuilder |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	aSpaceship := Spaceship with: id1.
	
	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (BlackHoleEffect new) at: 4.
	aTileBuilder addWormholeFrom: 5 to: 15.
	aTileCollection := aTileBuilder build.
	
	aBoard := (Board withSize: finishLine andLapsToWin: 1 and: aTileCollection).
	aGame := aGameBuilder
		          addSpaceship: aSpaceship;
			      addBoard: aBoard;   
		          addDice: (FixedDice onFace: 4);
		          build.
	
	aGame playTurn.
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).

]
