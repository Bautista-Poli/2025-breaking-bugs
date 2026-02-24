Class {
	#name : 'SpeedCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpeedCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfCardUsageAffectsOnlyOwnerAndNotTheRest [
	| aGame aSpaceship aGameBuilder positions aCard aSpaceship2 id1 id2 |
	
	positions := 6.
	aGameBuilder := GameBuilder new.
	aCard := SpeedCard new.

	id1 := 'nave1'. id2 := 'nave2'.

	aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
	aSpaceship2 := Spaceship with: (OrderedCollection with: SpeedCard new with: SpeedCard new) and: id2.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(6 4 6 4));
		build.
	
	aGame playCard: SpeedCard by: id1 targeting: id1.
	aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).
	self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 2).

	aGame playCard: SpeedCard by: id1 targeting: id1.
	aGame playTurn. aGame playTurn.
	
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).
	self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 2).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 15 and: 0). "6+1 + 6+2 = 15"
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 0).  "4 + 4 = 8"
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
        
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 2).
    aGame playCard: SpeedCard by: id targeting: id.
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 1).
    
    aGame playTurn.
    aGame playCard: SpeedCard by: id targeting: id.
    aGame playTurn.
    
    self assert: ((aGame spaceshipMatchWith: id) isAt: 15 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).


]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardAppliesEffectCorrectlyToEachSpaceshipAndConsumesCard [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 aCard1 aCard2 id1 id2 |
    
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCard1 := SpeedCard new.
    aCard2 := SpeedCard new.

    id1 := 'nave1'. id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: SpeedCard new) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2 with: SpeedCard new) and: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.
    
    aGame playCard: SpeedCard by: id1 targeting: id1.
    aGame playTurn. aGame playTurn.
    
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).
    self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 2).
    
    aGame playTurn.
    aGame playCard: SpeedCard by: id2 targeting: id2.
    aGame playTurn.
    
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).
    self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 1).
    
    aGame playTurn. aGame playTurn.
    "Nave 1: (6+1) + (6+1) + (6+1) = 21"
    "Nave 2: 4 + 4 + (4+1) + (4+1)? Ajustado a los turnos del test original"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 21 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 14 and: 0).

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
        
    aGame playCard: SpeedCard by: id targeting: id.
    aGame playTurn.

    self assert: ((aGame spaceshipMatchWith: id) isAt: 7 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).
]

{ #category : 'tests' }
SpeedCardTest >> testShowsErrorIfSpeedCardWantsToBePlayedOutsideOwnersTurn [
	| aGameBuilder aSpaceship1 aSpaceship2 aGame aCard id1 id2 |
	aGameBuilder := GameBuilder new.
	aCard := SpeedCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.

	aSpaceship1 := Spaceship with: (OrderedCollection with: aCard) and: id1.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		addSpaceship: aSpaceship1;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(1));
		build.

	aGame playTurn.

	self
		should: [ aGame playCard: SpeedCard by: id1 targeting: id1 ]
		raise: Error
		withMessageText: 'Card cannot be played at this turn'.

	"Chequeo extra: la carta sigue en la mano"
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.


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
		
	aGame playCard: SpeedCard by: id targeting: id.
	aGame playCard: SpeedCard by: id targeting: id.
	aGame playTurn.
	
	"6 (dado) + 1 (speed1) + 1 (speed2) = 8"
	self assert: ((aGame spaceshipMatchWith: id) isAt: 8 and: 0).
	self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

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

    aGame playCard: SpeedCard by: id1 targeting: id1.
    aGame playCard: AccelerationCard by: id1 targeting: nil.
    
    aGame playTurn. "Nave 1: 5 (dado) + 1 (speed) + 1 (accel) = 7"
    aGame playTurn. "Nave 2: 5 (dado) + 1 (accel) = 6"

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 7 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).
]
