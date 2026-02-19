Class {
	#name : 'HyperSpaceJumpTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
HyperSpaceJumpTest >> testWhenSpaceshipLandsOnHyperSpaceJumpNearFinishThenItDoesNotGoBelowStart [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 19.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: HyperSpaceJumpEffect new at: 17.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 17);
		         build.

	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.


	
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
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 17);
		         build.

	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id) getPosition equals: finishLine.



	
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
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id) getShields equals: 2.

	
]
