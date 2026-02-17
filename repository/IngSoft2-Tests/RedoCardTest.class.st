Class {
	#name : 'RedoCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingACancellationCardThenTheFirstActivePermanentCardIsCancelled [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherSpeedCard aCollectionOfCards aCancellationCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    anotherSpeedCard := SpeedCard new.
    aCancellationCard := CancelationCard new.
    aRedoCard := RedoCard new.
	 aCollectionOfCards	:= (OrderedCollection with: aSpeedCard with: aRedoCard with: aCancellationCard with: anotherSpeedCard).
    
    aSpaceship := Spaceship with: aCollectionOfCards and: 'nave1'.
        
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.


    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playCard: anotherSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame play: aCancellationCard by: aSpaceship affecting: aSpeedCard targeting: nil.
    aGame play: aRedoCard by: aSpaceship affecting: anotherSpeedCard targeting: nil.

    aGame playTurn.

    self assert: aGame activePermanentCards isEmpty.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAMercenaryCardThenTheSpaceshipHas2Mercenaries [
    | aGame aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position1 aMercenaryCard aRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aMercenaryCard := MercenaryCard new.
    aRedoCard := RedoCard new.
    aSpaceship := Spaceship with: (OrderedCollection
                                    with: aMercenaryCard
                                    with: aRedoCard) and: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'. 
	aSpaceship3 := Spaceship with: 'nave3'.
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.


    aGame playCard: aMercenaryCard by: aSpaceship targeting: aSpaceship2.
    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship3.
    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 2.
    
    self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship2).
    self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship3).
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARedoCardThenTheFirstEffectIsReapplied [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    anotherRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection 
                                    with: aSpeedCard 
                                    with: aRedoCard 
                                    with: anotherRedoCard) and: 'nave1'.
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn. 
    
    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn. 
    
    aGame playCard: anotherRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn. 

    aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 33.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARepeatReappliesLastTileEffectOnTarget [
    | gameBuilder board titleBuilder dice spaceship1 spaceship2 spaceship3 repeatCard redoCard game |
    
    repeatCard := RepeatCard new.
    redoCard := RedoCard new.

    spaceship1 := Spaceship with: (OrderedCollection with: repeatCard with: redoCard) and: 'nave1'.
    spaceship2 := Spaceship with: 'nave2'. 
	 spaceship3 := Spaceship with: 'nave3'.

    titleBuilder := ((TilesBuilder with: 90)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4) build.
    board := Board withSize: 90 andWormholeFrom: 80 to: 89 and: titleBuilder .

    dice := FixedDice onFace: 4.
    gameBuilder := GameBuilder new.
    game := gameBuilder
                addSpaceship: spaceship1;
                addSpaceship: spaceship2;
                addSpaceship: spaceship3;
                addBoard: board;
                addDice: dice;
                build.

    game playTurn. game playTurn. game playTurn.

    self assert: (game spaceshipMatching: spaceship1) getPosition equals: 19. 
    self assert: (game spaceshipMatching: spaceship2) getPosition equals: 14. 
    self assert: (game spaceshipMatching: spaceship3) getPosition equals: 9. 

    game playCard: repeatCard by: spaceship1 targeting: spaceship2.
    
    self assert: (game spaceshipMatching: spaceship2) getPosition equals: 29.

    game playCard: redoCard by: spaceship1 targeting: spaceship2.

    self assert: (game spaceshipMatching: spaceship1) getPosition equals: 19.
    self assert: (game spaceshipMatching: spaceship2) getPosition equals: 39.
    self assert: (game spaceshipMatching: spaceship3) getPosition equals: 9.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingASpeedCardThenTheSpaceshipDoublesItsSpeed [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard) and: 'nave1'.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn. 
    aGame playTurn. 

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 23.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAnAccelerationCardThenAllSpaceshipsDoubleItsSpeed [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 anAccelerationCard aRedoCard |
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    anAccelerationCard := AccelerationCard new.
    aRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection
                                    with: anAccelerationCard
                                    with: aRedoCard) and: 'nave1'.
    aSpaceship2 := Spaceship with: 'nave2'.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

    aGame playCard: anAccelerationCard by: aSpaceship targeting: nil.
    aGame playTurn. aGame playTurn. 
    aGame playCard: aRedoCard by: aSpaceship targeting: nil.
    aGame playTurn. aGame playTurn. 
    aGame playTurn. aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 23.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 17.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardHavingNotUsedOtherBeforeThenNothingHappens [
    | aGame aSpaceship aGameBuilder position1 aRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aRedoCard := RedoCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aRedoCard) and: 'nave1'.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: position1);
                 build.
    

    aGame playCard: aRedoCard by: aSpaceship targeting: nil.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 0.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]
