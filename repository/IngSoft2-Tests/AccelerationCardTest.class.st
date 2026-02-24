Class {
	#name : 'AccelerationCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'id1',
		'id2',
		'gameBuilder',
		'accelerationCard'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
AccelerationCardTest >> setUp [
	super setUp.

	id1 := 'nave1'.
   id2 := 'nave2'.
	gameBuilder := GameBuilder new.
	accelerationCard := AccelerationCard new.
]

{ #category : 'tests' }
AccelerationCardTest >> testAccelerationAffectsTotalRollAndNotEachIndividualDice [
	| aGame spaceship1 |

	spaceship1 := Spaceship with: (OrderedCollection with: AccelerationCard new) and: id1.
	
	aGame := gameBuilder
		addSpaceship: spaceship1;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 3);
		addDice: (FixedDice onFace: 3);
		build.
		
	aGame play: AccelerationCard by: id1 affecting: nil targeting: nil.
	aGame playTurn. 
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 7 and: 0).
	

]

{ #category : 'tests' }
AccelerationCardTest >> testAccelerationEffectPersistsOverTurns [
	| aGame spaceship1 spaceship2 accelerationCard2 |
	
	accelerationCard2 := AccelerationCard new.
	spaceship1 := Spaceship with: (OrderedCollection with: accelerationCard) and: id1.
	spaceship2 := Spaceship with: (OrderedCollection with: accelerationCard2) and: id2.
	
	aGame := gameBuilder
		addSpaceship: spaceship1;
		addSpaceship: spaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(10 12));
		build.
		

	aGame play: AccelerationCard by: id1 affecting: nil targeting: nil.
	
	aGame playTurn. 
	aGame playTurn. 
	aGame playTurn. 
	aGame playTurn. 
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 22 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 26 and: 0).
	
	

]

{ #category : 'tests' }
AccelerationCardTest >> testIsValidIfAccelerationCardIncreasesMovementOfAllSpaceships [
    | game spaceship1 spaceship2 position1 position2 |
    
    position1 := 6.
    position2 := 4.
    
    spaceship1 := Spaceship with: (OrderedCollection with: accelerationCard) and: id1.
    spaceship2 := Spaceship with: (OrderedCollection new) and: id2.
    game := gameBuilder
        addSpaceship: spaceship1;
        addSpaceship: spaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.
    
    game play: AccelerationCard by: id1 affecting: nil targeting: nil.

    self assert: ((game spaceshipMatchWith: id1) getCards size) equals: 0.
    self assert: (game hasActivePermanentCardOfType: AccelerationCard).

    game playTurn. game playTurn.
    
    self assert: ((game spaceshipMatchWith: id1) isAt: position1+1 and: 0).
    self assert: ((game spaceshipMatchWith: id2) isAt: position2+1 and: 0).

	
	

]

{ #category : 'tests' }
AccelerationCardTest >> testWhenTwoAccelerationCardsAreActiveThenAllSpaceshipsMovePlusTwo [
	| aGame spaceship1 spaceship2 card2 |

	card2 := AccelerationCard new.
	
	spaceship1 := Spaceship with: (OrderedCollection with: accelerationCard ) and: id1.
	spaceship2 := Spaceship with: (OrderedCollection with: card2) and: id2.
	
	aGame := gameBuilder
		addSpaceship: spaceship1;
		addSpaceship: spaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 5);
		build.
		
	"Activamos ambas cartas"
	aGame play: AccelerationCard by: id1 affecting: nil targeting: nil.
	aGame playTurn. 
	aGame play: AccelerationCard by: id2 affecting: nil targeting: nil.
	aGame playTurn. 
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 6 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 7 and: 0).
	self assert: (aGame hasActivePermanentCardOfType: AccelerationCard).
	
	

]
