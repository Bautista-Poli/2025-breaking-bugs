Class {
	#name : 'CancelationCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CancelationCardTest >> testWhenAccelerationCardIsCanceledThenAllSpaceshipsMoveAtNormalSpeedAgain [
	| aGame aSpaceship aSpaceship2 aGameBuilder aAccelCard aCancelationCard id1 id2 |
	
	aGameBuilder := GameBuilder new.
	aAccelCard := AccelerationCard new.
	aCancelationCard := CancelationCard new.
	
	id1 := 'nave1'.
	id2 := 'nave2'.
	
	aSpaceship := Spaceship with: (OrderedCollection with: aAccelCard with: aCancelationCard) and: id1.
	aSpaceship2 := Spaceship with: id2.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (SequentialFixedDice onFaces: #(6 4 6 4));
		build.

	aGame playCard: AccelerationCard by: id1 targeting: nil.
	aGame playTurn. "Nave 1: 6+1=7"
	aGame playTurn. "Nave 2: 4+1=5"
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 7 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).

	aGame play: CancelationCard by: id1 affecting: AccelerationCard targeting: nil.
	aGame playTurn. "Nave 1: 7+6=13"
	aGame playTurn. "Nave 2: 5+4=9"

	self assert: ((aGame spaceshipMatchWith: id2) isAt: 9 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 13 and: 0).

	
	
	
]

{ #category : 'tests' }
CancelationCardTest >> testWhenCancelationCardPlayedThenMercenaryEffectIsReverted [
    | aGame aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position1 position2 aCancelationCard aPermanentCard id1 id2 id3 |

    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    aCancelationCard := CancelationCard new.
    aPermanentCard := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aPermanentCard with: aCancelationCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

	aGame playCard: MercenaryCard by: id1 targeting: id2.

    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.
    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 1.

	aGame play: CancelationCard by: id1 affecting: MercenaryCard targeting: id2.

    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.
    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 0.

]

{ #category : 'tests' }
CancelationCardTest >> testWhenRedoCardIsPlayedAfterCancelationCardThenAnotherPermanentCardIsCanceled [
	| aGame aSpaceship aGameBuilder aSpeedCard aAccelCard aCancelCard aRedoCard id |

	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aAccelCard := AccelerationCard new.
	aCancelCard := CancelationCard new.
	aRedoCard := RedoCard new.

	id := 'nave1'.

	aSpaceship := Spaceship with: (OrderedCollection
		with: aSpeedCard
		with: aAccelCard
		with: aCancelCard
		with: aRedoCard) and: id.

	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 5);
		build.

	aGame playCard: SpeedCard by: id targeting: id.
	aGame playCard: AccelerationCard by: id targeting: nil.
	self assert: (aGame hasActivePermanentCardOfType: SpeedCard).
	self assert: (aGame hasActivePermanentCardOfType: AccelerationCard).

	aGame play: CancelationCard by: id affecting: SpeedCard targeting: nil.
	self deny: (aGame hasActivePermanentCardOfType: SpeedCard).
	self assert: (aGame hasActivePermanentCardOfType: AccelerationCard).

	aGame play: RedoCard by: id affecting: AccelerationCard targeting: id.
	self deny: (aGame hasActivePermanentCardOfType: SpeedCard).
	self deny: (aGame hasActivePermanentCardOfType: AccelerationCard).
	
	"Asumiendo que hasCards: o similar reemplaza getCards isEmpty"
	self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id) isAt: 5 and: 0).

]

{ #category : 'tests' }
CancelationCardTest >> testWhenSpeedCardIsCanceledThenSpaceshipMovesAtNormalSpeedAgain [
	| aGame aSpaceship aGameBuilder aSpeedCard aCancelationCard id |

	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aCancelationCard := CancelationCard new.

	id := 'nave1'.
	aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aCancelationCard) and: id.

	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
		addDice: (FixedDice onFace: 6);
		build.

	aGame playCard: SpeedCard by: id targeting: id.
	aGame playTurn.
	self assert: (aGame hasActivePermanentCardOfType: SpeedCard).

	aGame play: CancelationCard by: id affecting: SpeedCard targeting: nil.
	aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id) isAt: 13 and: 0).
	self deny: (aGame hasActivePermanentCardOfType: SpeedCard).
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
