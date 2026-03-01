Class {
	#name : 'HyperGravityTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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
