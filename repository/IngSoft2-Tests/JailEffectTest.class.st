Class {
	#name : 'JailEffectTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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
        addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(3 6 4)) ;
		  addDice: (SequentialFixedDice on: 6 andFixedNumbers: #(3 6 4)) ;
        build.
    
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 6.
    self assert: (aGame spaceshipMatchWith: id) isInJail.
    
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 18.
    self deny: (aGame spaceshipMatchWith: id) isInJail.
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
        addDice: (FixedDice on: 6 andFixedNumber: 3) ;
        build.
    
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 3.
    self assert: (aGame spaceshipMatchWith: id) isInJail.
    
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 3.
]
