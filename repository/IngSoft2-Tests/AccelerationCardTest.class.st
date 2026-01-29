Class {
	#name : 'AccelerationCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
AccelerationCardTest >> testAccelerationCardIncreasesMovementWithNewProtocol [
    | game spaceship1 spaceship2 accelerationCard position1 position2 |
    
    position1 := 6.
    position2 := 4.
    
    accelerationCard := AccelerationCard new.
    spaceship1 := Spaceship with: (OrderedCollection with: accelerationCard).
    spaceship2 := Spaceship with: (OrderedCollection new).
    
    game := GameBuilder new
        addSpaceship: spaceship1;
        addSpaceship: spaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.
    

    game playCard: accelerationCard by: spaceship1 targeting: nil.

    self assert: ((game spaceshipMatching: spaceship1) getCards size) equals: 0.
    self assert: (game activePermanentCards includes: accelerationCard).

    game playRound.
    
    self assert: (game spaceshipMatching: spaceship1) getPosition equals: position1 + 1.
    self assert: (game spaceshipMatching: spaceship2) getPosition equals: position2 + 1.
	
	

]

{ #category : 'tests' }
AccelerationCardTest >> testIsValidIfAcelerationCardAppliesEffectCorrectlyToAllSpaceshipsAndConsumesCard [ 

	| aGame aSpaceship aGameBuilder position1 position2 aCard aSpaceship2 |
	
	position1 := 6.
	position2 := 4.
	aGameBuilder := GameBuilder new.
	aCard := AccelerationCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: (aCard) with: (aCard)).
	aSpaceship2 := Spaceship with: (OrderedCollection with: (aCard) with: (aCard)).
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		 			addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
					addDice: (SequentialFixedDice onFaces: {position1 . position2});
		         build.
	
	aGame playRoundUsing: aCard of: aSpaceship.
	self assert: ((aGame spaceshipMatching: aSpaceship) getCards size) equals: 1.
	self assert: ((aGame spaceshipMatching: aSpaceship2) getCards size) equals: 2.
	
	aGame playRound.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: position1*2 + 1.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: position2*2 + 2.
	
	
	

]
