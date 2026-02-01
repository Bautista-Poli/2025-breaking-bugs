Class {
	#name : 'SpeedCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfCardUsageAffectsOnlyOwnerAndNotTheRest [
	| aGame aSpaceship aGameBuilder positions aCard aSpaceship2 |
	
	positions := 6.
	aGameBuilder := GameBuilder new.
	aCard := SpeedCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new).
	aSpaceship2 := Spaceship with: (OrderedCollection with: SpeedCard new with: SpeedCard new).
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(6 4 6 4));
		build.
	

	aGame playCard: (aGame spaceshipMatching: aSpaceship) getCards first by: aSpaceship targeting: aSpaceship.
	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 2.

	aGame playCard: (aGame spaceshipMatching: aSpaceship) getCards first by: aSpaceship targeting: aSpaceship.
	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 15.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 8.
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfCardUsageIsOnlyRemovedFromOwnersHand [
    | aGame aSpaceship aGameBuilder position1 position2 aCard |
    
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCard := SpeedCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: {position1. position1});
        build.
        
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
    aGame playCard: aCard by: aSpaceship targeting: aSpaceship.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
    aGame playTurn. 
    aGame playCard: (aGame spaceshipMatching: aSpaceship) getCards first by: aSpaceship targeting: aSpaceship.
    aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 15.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardAppliesEffectCorrectlyToEachSpaceshipAndConsumesCard [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 aCard1 aCard2 |
    
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCard1 := SpeedCard new.
    aCard2 := SpeedCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: SpeedCard new).
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2 with: SpeedCard new).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: {position1 . position2});
        build.
    
    aGame playCard: aCard1 by: aSpaceship targeting: aSpaceship.
    aGame playTurn. aGame playTurn. 
    
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
    self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 2.
    
	aGame playTurn. 
    aGame playCard: aCard2 by: aSpaceship2 targeting: aSpaceship2.
    aGame playTurn. 
    
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
    self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 1.
    

    aGame playTurn. aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 21.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 14.
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardIncrementsPositionDynamically [
    | aGame aSpaceship aGameBuilder position aCard |
    
    position := 6.
    aGameBuilder := GameBuilder new.
    aCard := SpeedCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position);
        build.
        
    aGame playCard: aCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 7.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
]

{ #category : 'tests' }
SpeedCardTest >> testSpaceshipUsesTwoSpeedCardsAndBonusesAccumulateImmediately [
	| aGame aSpaceship aGameBuilder positions aCard1 aCard2 |
	
	positions := 6.
	aGameBuilder := GameBuilder new.
	aCard1 := SpeedCard new.
	aCard2 := SpeedCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: aCard2).
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		addDice: (FixedDice onFace: positions);
		build.
		
	aGame playCard: aCard1 by: aSpaceship targeting: aSpaceship.
	aGame playCard: aCard2 by: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 8.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
]

{ #category : 'tests' }
SpeedCardTest >> testSpeedAndAccelerationBonusesAccumulateForTargetSpaceship [
    | aGame aSpaceship aSpaceship2 aGameBuilder aSpeedCard aAccelerationCard |
    
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aAccelerationCard := AccelerationCard new. 
    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aAccelerationCard).
    aSpaceship2 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: 5);
        build.


    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playCard: aAccelerationCard by: aSpaceship targeting: nil.
    
    aGame playTurn. aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 7.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 6.
]
