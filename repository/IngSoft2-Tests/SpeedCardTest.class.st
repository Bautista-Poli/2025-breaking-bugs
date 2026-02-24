Class {
	#name : 'SpeedCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'aCard',
		'aSpaceship',
		'position'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
SpeedCardTest >> setUp [
	super setUp.

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aCard := SpeedCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
	position := 6.
]

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
	| aGame aSpaceship2 |
	
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
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 15 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 0).
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardAppliesEffectCorrectlyToEachSpaceshipAndConsumesCard [
    | aGame aSpaceship2 position2 aCard2  |
    
    position2 := 4.
    aCard2 := SpeedCard new.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2 with: SpeedCard new) and: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position. position2 });
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
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 21 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 14 and: 0).

]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfSpeedCardIncrementsPositionDynamically [
    | aGame |
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position);
        build.
        
    aGame playCard: SpeedCard by: id1 targeting: id1.
    aGame playTurn.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 7 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).
]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfaSpeedCardIsOnlyRemovedFromOwnersHand [
    | aGame  position2  aSpaceship2 |
    
    position2 := 4.
	 aSpaceship2 := Spaceship with: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
		  addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { 6. 6 });
        build.
        
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).
    aGame playCard: SpeedCard by: id1 targeting: id1.
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).
	 self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 2).
    
	 aGame playCard: SpeedCard by: id1 targeting: id1.
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).
	 self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 2).


]

{ #category : 'tests' }
SpeedCardTest >> testIsValidIfaSpeedCardIsRemovedFromOwnersHand [
    | aGame  |
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { 6. 6 });
        build.
        
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).
    aGame playCard: SpeedCard by: id1 targeting: id1.
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 1).


]

{ #category : 'tests' }
SpeedCardTest >> testShowsErrorIfSpeedCardWantsToBePlayedOutsideOwnersTurn [
	| aSpaceship2 aGame  |

	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(1));
		build.

	aGame playTurn.

	self
		should: [ aGame playCard: SpeedCard by: id1 targeting: id1 ]
		raise: Error
		withMessageText: 'Card cannot be played at this turn'.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.


]

{ #category : 'tests' }
SpeedCardTest >> testSpaceshipUsesTwoSpeedCardsAndBonusesAccumulateImmediately [
	| aGame positions aCard2 |
	
	positions := 6.
	aCard2 := SpeedCard new.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		addDice: (FixedDice onFace: positions);
		build.
		
	aGame playCard: SpeedCard by: id1 targeting: id1.
	aGame playCard: SpeedCard by: id1 targeting: id1.
	aGame playTurn.
	
	"6 (dado) + 1 (speed1) + 1 (speed2) = 8"
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 8 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).

]

{ #category : 'tests' }
SpeedCardTest >> testSpeedAndAccelerationBonusesAccumulateForTargetSpaceship [
    | aGame aSpaceship2 aAccelerationCard  |
    
    aAccelerationCard := AccelerationCard new.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aAccelerationCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: 5);
        build.

    aGame playCard: SpeedCard by: id1 targeting: id1.
    aGame playCard: AccelerationCard by: id1 targeting: nil.
    
    aGame playTurn.
    aGame playTurn.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 7 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).
]
