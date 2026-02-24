Class {
	#name : 'MercenaryCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'id3',
		'aCard',
		'aSpaceship3',
		'aSpaceship2',
		'aCard2'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
MercenaryCardTest >> assert: aSpaceshipId hasMercenaryWithId: aMercenaryId in: aGame [
	self assert: ((aGame spaceshipMatchWith: aSpaceshipId) getMercenaries
		anySatisfy: [ :each | each matchesId: aMercenaryId ]).

]

{ #category : 'tests' }
MercenaryCardTest >> deny: anOwnerId hasMercenaryWithId: aMercenaryId in: aGame [
	self deny: ((aGame spaceshipMatchWith: anOwnerId) getMercenaries
		anySatisfy: [ :each | each matches: aMercenaryId ]).

]

{ #category : 'running' }
MercenaryCardTest >> setUp [
	super setUp.

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aCard := MercenaryCard new.
	aCard2 := MercenaryCard new.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
]

{ #category : 'tests' }
MercenaryCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
MercenaryCardTest >> testInvalidWhenSpaceshipTriesToHireASpaceshipThatIsAlreadyAMercenary [
    | aSpaceship  aGame |

    aGameBuilder := GameBuilder new.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    aSpaceship3 := Spaceship with: (OrderedCollection with: aCard2) and: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6));
        build.
	 aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id2) hasOwner.

    self deny: id3 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id3) getCards size equals: 1.

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipCannotHireSameMercenaryTwiceEvenWithTwoDifferentMercenariesCards [

	|  aSpaceship aGame|
	aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aCard2) and: id1.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
		         addDice: (SequentialFixedDice onFaces: #(4 2 6));
		         build.

	aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
	self assert: id1 hasMercenaryWithId: id2 in: aGame.

	self
		should: [ aGame play: MercenaryCard by: id1 affecting: nil targeting: id2. ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'.

	self assert: id1 hasMercenaryWithId: id2 in: aGame.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.



]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipHiresAnotherTheStateChangesOnlyFortheOwner [
    | aSpaceship aGame |

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2) and: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
        addDice: (FixedDice onFace: 8);
        build.
        
    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
	aGame playTurn.

	self
		should: [ aGame play: MercenaryCard by: id2 affecting: nil targeting: id1. ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'.

		
	

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipThatUseMercenaryCardWantsToHaveHimselfAsMercenary [
    | aSpaceship aGame|

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2));
        build.

    self assert: (aGame spaceshipMatchWith: id1) getMercenaries isEmpty.
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfSpaceshipCanPlayTwiceTheMercenaryCard [
    | aSpaceship aGame aSecondCard |

    aSecondCard := SpeedCard new.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard) and: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 5));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.


		
	

]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHasASpaceshipThatHeSpecifiesAsMercenary [
    | aSpaceship aGame |

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 4 6 2 7));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.

    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 2 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).

]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHastwoSpaceshipsThatHeSpecifiesAsMercenaries [
    | aSpaceship aGame |

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aCard2) and: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6 6 10 4));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
    aGame play: MercenaryCard by: id1 affecting: nil targeting: id3.

    self assert: ((aGame spaceshipMatchWith: id1) hasMercenariesAmount: 2).
    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: id1 hasMercenaryWithId: id3 in: aGame.

    6 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 10 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 12 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 10 and: 0).

]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfNoBattleOccursWhenSpaceshipAndMercenaryLandOnSameTile [
    | aSpaceship aGame |

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 3 2 4 10));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.

    6 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 6 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).

    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 3).
    self assert: ((aGame spaceshipMatchWith: id2) hasShields: 3).



]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipAndMercenaryWinsWhenSpaceshipOrMercenaryHasHighestDice [
    | aSpaceship aGame |
   
    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 5 1 7));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 19 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
    
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 3).
    self assert: ((aGame spaceshipMatchWith: id2) hasShields: 3).
    self assert: ((aGame spaceshipMatchWith: id3) hasShields: 2).
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipCanPlayAnotherCardHavingAMercenary [
    | aSpaceship aGame aSecondCard |
    aSecondCard := AccelerationCard new.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard) and: id1.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 9));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
    aGame play: AccelerationCard by: id1 affecting: nil targeting: id2.
    
    self assert: (aGame spaceshipMatchWith: id1) getCards isEmpty.
    
    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 10 and: 0).

]

{ #category : 'tests' }
MercenaryCardTest >> testWhenASpaceshipAndHisMercenaryLoseABattleThenBothLoseAShield [
    | aSpaceship aGame |

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 10 1 1));
        build.

    aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 2).
    self assert: ((aGame spaceshipMatchWith: id2) hasShields: 2).
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).

]
