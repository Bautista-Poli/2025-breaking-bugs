Class {
	#name : 'CancelationCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CancelationCardTest >> testWhenAccelerationCardIsCanceledThenAllSpaceshipsMoveAtNormalSpeedAgain [
	| aGame aSpaceship aSpaceship2 aGameBuilder aAccelCard aCancelationCard |
	
	aGameBuilder := GameBuilder new.
	aAccelCard := AccelerationCard new.
	aCancelationCard := CancelationCard new.
	
	aSpaceship := Spaceship with: (OrderedCollection with: aAccelCard with: aCancelationCard).
	aSpaceship2 := Spaceship new.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(6 4 6 4));
		build.


	aGame playCard: aAccelCard by: aSpaceship targeting: nil.
	aGame playRound.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 7.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 5.
	aGame play: aCancelationCard by: aSpaceship affecting: aAccelCard targeting: nil.

	aGame playRound.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 9.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 13.
	
	
	
]

{ #category : 'tests' }
CancelationCardTest >> testWhenCancelationCardPlayedThenMercenaryEffectIsReverted [
    | aGame aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position1 position2 aCancelationCard aPermanentCard |
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCancelationCard := CancelationCard new.
    aPermanentCard := MercenaryCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection
                                    with: aPermanentCard
                                    with: aCancelationCard).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

	aGame playCard: aPermanentCard by: aSpaceship targeting: aSpaceship2.

    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.

	aGame play: aCancelationCard by: aSpaceship affecting: aPermanentCard targeting: aSpaceship2.

    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 0.
]

{ #category : 'tests' }
CancelationCardTest >> testWhenRedoCardIsPlayedAfterCancelationCardThenAnotherPermanentCardIsCanceled [
	| aGame aSpaceship aGameBuilder aSpeedCard aAccelCard aCancelCard aRedoCard |
	
	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aAccelCard := AccelerationCard new.
	aCancelCard := CancelationCard new.
	aRedoCard := RedoCard new.
	
	"Nave 1 arranca con todo el mazo necesario"
	aSpaceship := Spaceship with: (OrderedCollection 
		with: aSpeedCard 
		with: aAccelCard 
		with: aCancelCard 
		with: aRedoCard).
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 5);
		build.


	aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
	aGame playCard: aAccelCard by: aSpaceship targeting: nil.
	self assert: aGame activePermanentCards size equals: 2.

	aGame play: aCancelCard by: aSpaceship affecting: aSpeedCard targeting: nil.
	self assert: aGame activePermanentCards size equals: 1.
	self assert: (aGame activePermanentCards includes: aAccelCard).

	
	aGame play: aRedoCard by: aSpaceship affecting: aAccelCard targeting: aSpaceship.
	self assert: aGame activePermanentCards isEmpty.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
	
	aGame playRound.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 5.
]

{ #category : 'tests' }
CancelationCardTest >> testWhenSpeedCardIsCanceledThenSpaceshipMovesAtNormalSpeedAgain [
	| aGame aSpaceship aGameBuilder aSpeedCard aCancelationCard |
	
	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aCancelationCard := CancelationCard new.
	
	aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aCancelationCard).
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 6);
		build.

	aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
	aGame playRound.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 7.

	aGame play: aCancelationCard by: aSpaceship affecting: aSpeedCard targeting: nil.
	aGame playRound.

	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 13. "7+6"
	self assert: aGame activePermanentCards isEmpty.
]

{ #category : 'tests' }
CancelationCardTest >> testWhenTryingToCancelACardThatIsNotActiveThenItIsNotPossible [
	| aGame aSpaceship aGameBuilder aCancellationCard anAccelerationCard |
	
	aGameBuilder := GameBuilder new.
	aCancellationCard := CancelationCard new.
	anAccelerationCard := AccelerationCard new.
	
	aSpaceship := Spaceship with: (OrderedCollection with: aCancellationCard).
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 4);
		build.


	self should: [ 
		aGame play: aCancellationCard by: aSpaceship affecting: anAccelerationCard targeting: nil 
	] raise: Error.
]
