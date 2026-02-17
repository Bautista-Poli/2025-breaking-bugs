Class {
	#name : 'HyperSpaceJumpTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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

	aBoard := Board
		          withSize: finishLine
		          andWormholeFrom: 5
		          to: 15
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
