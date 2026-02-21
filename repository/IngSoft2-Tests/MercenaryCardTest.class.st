Class {
	#name : 'MercenaryCardTest',
	#superclass : 'TestCase',
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
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aCard1 := MercenaryCard new.
    aCard2 := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard1) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: (OrderedCollection with: aCard2) and: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id2) hasOwner.

    self deny: id3 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id3) getCards size equals: 1.

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipCannotHireSameMercenaryTwiceEvenWithTwoDifferentMercenariesCards [

	| aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	aCard1 := MercenaryCard new.
	aCard2 := MercenaryCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: aCard2) and: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
		         addDice: (SequentialFixedDice onFaces: #(4 2 6));
		         build.

	aGame playCard: MercenaryCard by: id1 targeting: id2.
	self assert: id1 hasMercenaryWithId: id2 in: aGame.

	self
		should: [ aGame playCard: MercenaryCard by: id1 targeting: id2 ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'.

	self assert: id1 hasMercenaryWithId: id2 in: aGame.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.



]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipHiresAnotherTheStateChangesOnlyFortheOwner [
    | aGameBuilder aSpaceship aSpaceship2 aGame aCard aCard2 id1 id2 |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aCard2 := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2) and: id2.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
        addDice: (FixedDice onFace: 8);
        build.
        
    aGame playCard: MercenaryCard by: id1 targeting: id2.
	aGame playTurn.

	self
		should: [ aGame playCard: MercenaryCard by: id2 targeting: id1 ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'.

		
	

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipThatUseMercenaryCardWantsToHaveHimselfAsMercenary [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard aCollectionOfCards id1 id2 id3 |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
	aCollectionOfCards := (OrderedCollection with: aCard with: SpeedCard new).

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: aCollectionOfCards and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    
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
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard aSecondCard id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSecondCard := SpeedCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 5));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.


		
	

]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHasASpaceshipThatHeSpecifiesAsMercenary [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 4 "|Batallan|" "Tira la nave 3 ->"6 "Tira la nave 1 y su mercenaria ->"2 7));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.

    self assert: id1 hasMercenaryWithId: id2 in: aGame.

    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 4.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 2.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.


]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHastwoSpaceshipsThatHeSpecifiesAsMercenaries [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aCard1 := MercenaryCard new.
    aCard2 := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: aCard2) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6 6 10 4));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.
    aGame playCard: MercenaryCard by: id1 targeting: id3.

    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
    self assert: id1 hasMercenaryWithId: id2 in: aGame.
    self assert: id1 hasMercenaryWithId: id3 in: aGame.

    aGame playTurn. aGame playTurn. aGame playTurn.
    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 10.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 12.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 10.


]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfNoBattleOccursWhenSpaceshipAndMercenaryLandOnSameTile [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 3 2 4 10));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.

    aGame playTurn. aGame playTurn. aGame playTurn.
    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 6.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 6.

    self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
    self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.



]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipAndMercenaryWinsWhenSpaceshipOrMercenaryHasHighestDice [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard id1 id2 id3 |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 5 1 7));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.
    aGame playTurn. aGame playTurn. aGame playTurn.
	"Batallan, spaceship3 saca un 5 mientras que una de las otras dos saca un 7"

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 4.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 19.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.
    
    self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
    self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.
    self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.

]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipCanPlayAnotherCardHavingAMercenary [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard aSecondCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSecondCard := AccelerationCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 9));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.
    aGame playCard: AccelerationCard by: id1 targeting: id2.
    
    self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.
    
    aGame playTurn. aGame playTurn. aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 5.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 10.

]

{ #category : 'tests' }
MercenaryCardTest >> testWhenASpaceshipAndHisMercenaryLoseABattleThenBothLoseAShield [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 10 1 1));
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.
    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
    self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.

]
