Class {
	#name : 'AccelerationCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
AccelerationCardTest >> testIsValidIfAccelerationCardIncreasesMovementOfAllSpaceships [
    | game spaceship1 spaceship2 accelerationCard position1 position2 id1 id2 |
    
    position1 := 6.
    position2 := 4.
    
    id1 := 'nave1'.
    id2 := 'nave2'.
    
    accelerationCard := AccelerationCard new.
    spaceship1 := Spaceship with: (OrderedCollection with: accelerationCard) and: id1.
    spaceship2 := Spaceship with: (OrderedCollection new) and: id2.
    
    game := GameBuilder new
        addSpaceship: spaceship1;
        addSpaceship: spaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.
    
    game playCard: AccelerationCard by: id1 targeting: nil.

    self assert: ((game spaceshipMatchWith: id1) getCards size) equals: 0.
    self assert: (game activePermanentCards anySatisfy: [ :card | card isKindOf: AccelerationCard ]).

    game playTurn. game playTurn.
    
    self assert: ((game spaceshipMatchWith: id1) isAt: position1+1 and: 0).
    self assert: ((game spaceshipMatchWith: id2) isAt: position2+1 and: 0).

	
	

]
