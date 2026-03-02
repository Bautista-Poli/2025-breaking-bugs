Class {
	#name : 'HyperGravityTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
HyperGravityTest >> testIsValidIfTwoDifferentHyperGravityTilesWithDifferentRequiredValuesWorkIndependently [
    | aGame aSpaceship aSpaceship2 aGameBuilder aBoard aTileBuilder aTileCollection id id2|
    aGameBuilder := GameBuilder new.
    id := 'nave1'.
	 id2 := 'nave2'.
    aSpaceship := Spaceship with: id.
	 aSpaceship2 := Spaceship with: id2.

    aTileBuilder := TilesBuilder with: 60.
    aTileBuilder with: (HyperGravityEffect withRoll: 7) at: 5.
	 aTileBuilder with: (HyperGravityEffect withRoll: 5) at: 3.
    aTileBuilder addWormholeFrom: 50 to: 55.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
	     addSpaceship: aSpaceship2;
        addBoard: aBoard;
        addDice: (SequentialFixedDice on: 10 andFixedNumbers: #(2 4 4 5 2 2));
        addDice: (SequentialFixedDice on: 10 andFixedNumbers: #(1 1 1 2 2 2));
        build.

    aGame playTurn.
	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 3 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
	 aGame playTurn.
	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 3 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
    aGame playTurn.
	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 7 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id2) isAt: 9 and: 0).
]

{ #category : 'tests' }
HyperGravityTest >> testWhenSpaceshipInHyperGravityDoesNotRollRequiredValueItStays [
    | aGame aSpaceship aGameBuilder aBoard aTileBuilder aTileCollection id |
    aGameBuilder := GameBuilder new.
    id := 'nave1'.
    aSpaceship := Spaceship with: id.

    aTileBuilder := TilesBuilder with: 60.
    aTileBuilder with: (HyperGravityEffect withRoll: 7) at: 4.
    aTileBuilder addWormholeFrom: 50 to: 55.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: aBoard;
        addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(2 2));
        addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(2 1));
        build.

    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).
]

{ #category : 'tests' }
HyperGravityTest >> testWhenSpaceshipInHyperGravityRollsRequiredValueItIsReleasedAndMoves [
    | aGame aSpaceship aGameBuilder aBoard aTileBuilder aTileCollection id |
    aGameBuilder := GameBuilder new.
    id := 'nave1'.
    aSpaceship := Spaceship with: id.

    aTileBuilder := TilesBuilder with: 60.
    aTileBuilder with: (HyperGravityEffect withRoll: 7) at: 4.
    aTileBuilder addWormholeFrom: 50 to: 55.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: aBoard;
        addDice: (SequentialFixedDice on: 10 andFixedNumbers: #(2 4 3));
        addDice: (SequentialFixedDice on: 10 andFixedNumbers: #(2 3 1));
        build.

    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).

	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 8 and: 0).
]
