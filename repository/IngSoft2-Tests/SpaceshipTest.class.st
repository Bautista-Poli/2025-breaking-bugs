Class {
	#name : 'SpaceshipTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpaceshipTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
SpaceshipTest >> testSpaceshipMovesWhatItGotFromTheDice [
    | aGame id aBoard diceNum |
    id := 'nave1'.
	 diceNum := 3.
    aBoard := Board  withSize: 20 andWormholeFrom: 10 to: 12.
    aGame := GameBuilder new
        addSpaceship: (Spaceship with: id);
        addBoard: aBoard;
        addDice: (FixedDice onFace: diceNum);
        build.
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: diceNum.
]

{ #category : 'tests' }
SpaceshipTest >> testWhenCreatingASpaceshipThenItIsAtTheInitialPosition [

	| aSpaceship |
	aSpaceship := Spaceship with: 'nave1'.

	self assert: aSpaceship getPosition equals: 0
]

{ #category : 'tests' }
SpaceshipTest >> testWhenSpaceshipMovesAndGoesNegativeItStaysAtZero [
    | aGame id aBoard aTileBuilder aTileCollection |
    id := 'nave1'.
    aTileBuilder := TilesBuilder with: 20.
    aTileBuilder with: BlackHoleEffect new at: 2.
    aTileBuilder addWormholeFrom: 5 to: 10.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := GameBuilder new
        addSpaceship: (Spaceship with: id);
        addBoard: aBoard;
        addDice: (FixedDice onFace: 2);
        build.
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.
]
