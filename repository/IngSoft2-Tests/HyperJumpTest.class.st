Class {
	#name : 'HyperJumpTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
HyperJumpTest >> testWhenHyperJumpMovesASpaceshipOntoAnotherSpaceshipThenTheyBattle [

	| aSpaceship1 aSpaceship2 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 |

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.

	aSpaceship1 := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.

	finishLine := 60.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (HyperJumpEffect withDescendingLightYearsFrom: 90 step: 30) at: 4.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: aSpaceship1;
		addSpaceship: aSpaceship2;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(19 4 6 8));
		build.

	aGame playTurn.  
	aGame playTurn.   
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 0.


	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.

]

{ #category : 'tests' }
HyperJumpTest >> testWhenSpaceshipLandsOnHyperJumpNearFinishThenItDoesNotGoBelowStart [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 20.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 18.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 18);
		         build.

	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.

]

{ #category : 'tests' }
HyperJumpTest >> testWhenSpaceshipLandsOnHyperJumpNearFinishThenItFinishesTheGame [
	| aSpaceship aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	finishLine := 20.

	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 18.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 18);
		         build.

	aGame playTurn.

	"De nuevo, ajustá según tu convención de ganar:"
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: finishLine.


]

{ #category : 'tests' }
HyperJumpTest >> testWhenSpaceshipsLandOnHyperSpaceJumpThenTheyAreMovedForwardAnAmountInLightYears [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aSpaceship3 aTileBuilder aTileCollection id1 id2 id3 |

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (HyperJumpEffect withDescendingLightYearsFrom: 90 step: 30) at: 4.
	aTileCollection := aTileBuilder build.
	"andWormholeFrom: 5 to: 15"
	aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn. aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 14.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.

]

{ #category : 'tests' }
HyperJumpTest >> testWhenSpaceshipsLandOnHyperSpaceJumpThenTheyAreMovedForwardAnAmountInParsecs [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aSpaceship3 aTileBuilder aTileCollection id1 id2 id3 |

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 4.
	aTileCollection := aTileBuilder build.
	"andWormholeFrom: 5 to: 15"
	aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn. aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 14.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.
]
