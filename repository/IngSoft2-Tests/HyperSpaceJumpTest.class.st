Class {
	#name : 'HyperSpaceJumpTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
HyperSpaceJumpTest >> testWhenHyperSpaceJumpMovesShipOntoOccupiedTileThenTheyBattle [
	| aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection ship1 ship2 id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	ship1 := Spaceship with: id1.
	ship2 := Spaceship with: id2.

	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: HyperSpaceJumpEffect new at: 1.
	aTileBuilder addWormholeFrom: 10 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: ship1;
		addSpaceship: ship2;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(5 1 2 9));
		build.

	aGame playTurn. "Nave 1 mueve 5 -> Pos 5"
	aGame playTurn. "Nave 2 mueve 1 -> Cae en HyperSpaceJump -> Salta a pos ocupada -> Batalla"
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) hasShields: 1).
	


	
]

{ #category : 'tests' }
HyperSpaceJumpTest >> testWhenSpaceshipLandsOnHyperSpaceJumpNearFinishThenItDoesNotGoBelowStart [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 19.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: HyperSpaceJumpEffect new at: 17.
	aTileBuilder addWormholeFrom: 5 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 17);
		         build.

	self assert: ((aGame spaceshipMatchWith: id) isAt: 0 and: 0).


	
]

{ #category : 'tests' }
HyperSpaceJumpTest >> testWhenSpaceshipLandsOnHyperSpaceJumpNearFinishThenItFinishesTheGame [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 19.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: HyperSpaceJumpEffect new at: 17.
	aTileBuilder addWormholeFrom: 5 to: 15.
	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 17);
		         build.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id) isAt: 2 and: 1).
]

{ #category : 'tests' }
HyperSpaceJumpTest >> testWhenSpaceshipLandsOnHyperSpaceJumpThenItIsMovedForward4PositionsAndLoosesAShield [

	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 19.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: HyperSpaceJumpEffect new at: 4.
	aTileBuilder addWormholeFrom: 5 to: 15.
	aTileCollection := aTileBuilder build.
	"andWormholeFrom: 5 to: 15"
	aBoard := Board
		          withSize: finishLine
					 andLapsToWin: 1
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id) isAt: 8 and: 0).
	self assert: (aGame spaceshipMatchWith: id) getShields equals: 2.

	
]
