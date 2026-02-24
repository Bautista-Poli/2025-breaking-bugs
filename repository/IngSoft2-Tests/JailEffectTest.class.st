Class {
	#name : 'JailEffectTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
JailEffectTest >> testWhenFreedomCardIsPlayedItReleasesTheSpaceshipFromJailOutsideOwnTurn [
    | aGame aSpaceship aSpaceship2 aGameBuilder aBoard aTileBuilder aTileCollection id1 id2 |
    aGameBuilder := GameBuilder new.
    id1 := 'nave1'.
    id2 := 'nave2'.
    aSpaceship := Spaceship with: (OrderedCollection with: FreedomCard new) and: id1.
    aSpaceship2 := Spaceship with: id2.
    
    aTileBuilder := TilesBuilder with: 20.
    aTileBuilder with: JailEffect new at: 3.
    aTileBuilder addWormholeFrom: 5 to: 10.
    aTileCollection := aTileBuilder build.
    
    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: aBoard;
        addDice: (SequentialFixedDice onFaces: #(3 4));
        build.
    
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id1) isInJail.
    
    aGame playCard: FreedomCard by: id1 targeting: id1.
    self deny: (aGame spaceshipMatchWith: id1) isInJail.
    
    aGame playTurn.
    aGame playTurn.
    self deny: (aGame spaceshipMatchWith: id1) isInJail.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 6 and: 0).
]

{ #category : 'tests' }
JailEffectTest >> testWhenSpaceshipInJailRollsMaximumItIsReleasedAndDoesNotMove [
    | aGame aSpaceship aGameBuilder aBoard aTileBuilder aTileCollection id |
    aGameBuilder := GameBuilder new.
    id := 'nave1'.
    aSpaceship := Spaceship with: id.
    
    aTileBuilder := TilesBuilder with: 20.
    aTileBuilder with: JailEffect new at: 6.
    aTileBuilder addWormholeFrom: 5 to: 10.
    aTileCollection := aTileBuilder build.
    
    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: aBoard;
        addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(3 6 4));
		  addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(3 6 4));
        build.
    
    aGame playTurn. "Mueve 3 + 3 = 6 -> Cae en Jail"
    self assert: ((aGame spaceshipMatchWith: id) isAt: 6 and: 0).
    self assert: (aGame spaceshipMatchWith: id) isInJail.
    
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 6 and: 0). 
    self deny: (aGame spaceshipMatchWith: id) isInJail.

	aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 14 and: 0).
]

{ #category : 'tests' }
JailEffectTest >> testWhenSpaceshipLandsOnJailItCannotMoveOnNextTurn [
    | aGame aSpaceship aGameBuilder aBoard aTileBuilder aTileCollection id |
    aGameBuilder := GameBuilder new.
    id := 'nave1'.
    aSpaceship := Spaceship with: id.
    
    aTileBuilder := TilesBuilder with: 20.
    aTileBuilder with: JailEffect new at: 3.
    aTileBuilder addWormholeFrom: 5 to: 10. 
    aTileCollection := aTileBuilder build.
    
    aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: aBoard;
        addDice: (FixedDice on: 6 andFixedNumber: 3);
        build.
    
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 3 and: 0).
    self assert: (aGame spaceshipMatchWith: id) isInJail.
    
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 3 and: 0).
]
