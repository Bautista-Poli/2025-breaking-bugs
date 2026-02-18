Class {
	#name : 'SpeedCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfCardUsageAffectsOnlyOwnerAndNotTheRest [
	| aGame aSpaceship aGameBuilder positions aCard aSpaceship2 id1 id2 |
	
	positions := 6.
	aGameBuilder := GameBuilder new.
	aCard := SpeedCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.

	aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
	aSpaceship2 := Spaceship with: (OrderedCollection with: SpeedCard new with: SpeedCard new) and: id2.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(6 4 6 4));
		build.
	
	aGame playCard: (aGame spaceshipMatchWith: id1) getCards first by: id1 targeting: id1.
	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 2.

	aGame playCard: (aGame spaceshipMatchWith: id1) getCards first by: id1 targeting: id1.
	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 2.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 15.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 8.

]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfCardUsageIsOnlyRemovedFromOwnersHand [
    | aGame aSpaceship aGameBuilder position1 position2 aCard id |
    
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCard := SpeedCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position1 });
        build.
        
    self assert: (aGame spaceshipMatchWith: id) getCards size equals: 2.
    aGame playCard: aCard by: id targeting: id.
    self assert: (aGame spaceshipMatchWith: id) getCards size equals: 1.
    aGame playTurn.
    aGame playCard: (aGame spaceshipMatchWith: id) getCards first by: id targeting: id.
    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 15.
    self assert: (aGame spaceshipMatchWith: id) getCards size equals: 0.


]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardAppliesEffectCorrectlyToEachSpaceshipAndConsumesCard [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 aCard1 aCard2 id1 id2 |
    
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCard1 := SpeedCard new.
    aCard2 := SpeedCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: SpeedCard new) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2 with: SpeedCard new) and: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.
    
    aGame playCard: aCard1 by: id1 targeting: id1.
    aGame playTurn. aGame playTurn.
    
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.
    self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 2.
    
	aGame playTurn.
    aGame playCard: aCard2 by: id2 targeting: id2.
    aGame playTurn.
    
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.
    self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 1.
    
    aGame playTurn. aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 21.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 14.


]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardIncrementsPositionDynamically [
    | aGame aSpaceship aGameBuilder position aCard id |
    
    position := 6.
    aGameBuilder := GameBuilder new.
    aCard := SpeedCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position);
        build.
        
    aGame playCard: aCard by: id targeting: id.
    aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 7.
    self assert: (aGame spaceshipMatchWith: id) getCards size equals: 0.

]

{ #category : 'tests' }
SpeedCardTest >> testSpaceshipUsesTwoSpeedCardsAndBonusesAccumulateImmediately [
	| aGame aSpaceship aGameBuilder positions aCard1 aCard2 id |
	
	positions := 6.
	aGameBuilder := GameBuilder new.
	aCard1 := SpeedCard new.
	aCard2 := SpeedCard new.

	id := 'nave1'.
	aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: aCard2) and: id.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		addDice: (FixedDice onFace: positions);
		build.
		
	aGame playCard: aCard1 by: id targeting: id.
	aGame playCard: aCard2 by: id targeting: id.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id) getCards size equals: 0.

]

{ #category : 'tests' }
SpeedCardTest >> testSpeedAndAccelerationBonusesAccumulateForTargetSpaceship [
    | aGame aSpaceship aSpaceship2 aGameBuilder aSpeedCard aAccelerationCard id1 id2 |
    
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aAccelerationCard := AccelerationCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aAccelerationCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: 5);
        build.

    aGame playCard: aSpeedCard by: id1 targeting: id1.
    aGame playCard: aAccelerationCard by: id1 targeting: nil.
    
    aGame playTurn. aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 7.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 6.

]
