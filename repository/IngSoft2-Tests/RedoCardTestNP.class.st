Class {
	#name : 'RedoCardTestNP',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RedoCardTestNP >> testWhenUsingARedoCardAfterUsingAMercenaryCardThenTheSpaceshipHas2Mercenaries [
    | aGame aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position1 aMercenaryCard aRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aMercenaryCard := MercenaryCard new.
    aRedoCard := RedoCard new.
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    aSpaceship := Spaceship with: (OrderedCollection
                                    with: aMercenaryCard
                                    with: aRedoCard).
                                    
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
RedoCardTestNP >> testWhenUsingARedoCardAfterUsingARedoCardThenTheFirstEffectIsReapplied [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    anotherRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection 
                                    with: aSpeedCard 
                                    with: aRedoCard 
                                    with: anotherRedoCard).
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.
    
    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.
    
    aGame playCard: anotherRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.

    aGame playRound.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 33.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RedoCardTestNP >> testWhenUsingARedoCardAfterUsingASpeedCardThenTheSpaceshipDoublesItsSpeed [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.

    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.
    aGame playRound.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 23.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RedoCardTestNP >> testWhenUsingARedoCardAfterUsingAnAccelerationCardThenAllSpaceshipsDoubleItsSpeed [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 anAccelerationCard aRedoCard |
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    anAccelerationCard := AccelerationCard new.
    aRedoCard := RedoCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection
                                    with: anAccelerationCard
                                    with: aRedoCard).
    aSpaceship2 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

    aGame playCard: anAccelerationCard by: aSpaceship targeting: nil.
    aGame playRound.
    aGame playCard: aRedoCard by: aSpaceship targeting: nil.
    aGame playRound.
    aGame playRound.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 23.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 17.
]
