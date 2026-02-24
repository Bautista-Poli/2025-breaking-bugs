Class {
	#name : 'MoonWalkTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'aSpaceship2',
		'aSpaceship',
		'finishLine',
		'aTileBuilder'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
MoonWalkTest >> setUp [
	super setUp.

	aGameBuilder := GameBuilder new. 
	id1 := 'nave1'. 
	id2 := 'nave2'. 
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder addWormholeFrom: 5 to: 10.
]

{ #category : 'tests' }
MoonWalkTest >> testMoonWalkCanMoveSpaceshipToLowerLaps [
	| aGame aBoard aTileCollection |
	aTileBuilder with: (MoonWalkEffect for: 20) at: 6.
	aTileCollection := aTileBuilder build.
	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 3
		          and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(24 6));
		         build.
	aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).


]

{ #category : 'tests' }
MoonWalkTest >> testMoonWalkDoesNotMoveSpaceshipBelowStartWhenInFirstLap [
	| aGame aBoard aTileCollection|
	aTileBuilder with: (MoonWalkEffect for: 6) at: 4.
	aTileCollection := aTileBuilder build.
	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 2
		          and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(2 4));
		         build.
	aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 4 and: 0).


]

{ #category : 'tests' }
MoonWalkTest >> testWhenMoonWalkMovesOtherShipOntoOccupiedTileThenTheyBattle [
    | aGame aBoard aTileCollection |

    aTileBuilder with: (MoonWalkEffect for: 6) at: 11.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 2 and: aTileCollection.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: aBoard;
        addDice: (SequentialFixedDice onFaces: #(17 11 1 6));
        build.

    aGame playTurn. "Nave 1 mueve a 7"
    aGame playTurn. 

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 11 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 3).
    self assert: ((aGame spaceshipMatchWith: id2) hasShields: 2).
]

{ #category : 'tests' }
MoonWalkTest >> testWhenSpaceshipLandsOnMoonWalkThenOtherSpaceshipMovesBack [

	| aGame aBoard aTileCollection |
	aTileBuilder with: (MoonWalkEffect for: 2) at: 6.
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

	4 timesRepeat:[aGame playTurn]. 

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 6 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 11 and: 0).

]
