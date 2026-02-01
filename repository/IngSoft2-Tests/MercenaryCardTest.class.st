Class {
	#name : 'MercenaryCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 |
    
    aGameBuilder := GameBuilder new.
    aCard1 := MercenaryCard new.
    aCard2 := MercenaryCard new.
    
    "Nave 1 tiene una carta, Nave 3 tiene otra"
    aSpaceship := Spaceship with: (OrderedCollection with: aCard1).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship with: (OrderedCollection with: aCard2).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6));
        build.


    aGame playCard: aCard1 by: aSpaceship targeting: aSpaceship2.
    
    self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship2).
    self assert: (aGame spaceshipMatching: aSpaceship2) hasOwner. 

    self deny: ((aGame spaceshipMatching: aSpaceship3) getMercenaries includes: aSpaceship2).
    self assert: (aGame spaceshipMatching: aSpaceship3) getCards size equals: 1.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipCannotHireSameMercenaryTwiceEvenWithTwoDifferentMercenariesCards [

	| aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 |
	aGameBuilder := GameBuilder new.
	aCard1 := MercenaryCard new.
	aCard2 := MercenaryCard new.
	aSpaceship := Spaceship with:
		              (OrderedCollection with: aCard1 with: aCard2).
	aSpaceship2 := Spaceship new.
	aSpaceship3 := Spaceship new.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
		         addDice: (SequentialFixedDice onFaces: #( 4 2 6 ));
		         build.

	aGame playCard: aCard1 by: aSpaceship targeting: aSpaceship2.
	self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.


	self
		should: [
		aGame playCard: aCard2 by: aSpaceship targeting: aSpaceship2 ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'.

	self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.
	"CAMBIAR No deberia ser 0 sino 1"
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipHiresAnotherTheStateChangesOnlyFortheOwner [
    | aGameBuilder aSpaceship aSpaceship2 aGame aCard aCard2|
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
	 aCard2 := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard ).
    aSpaceship2 := Spaceship with: (OrderedCollection with: aCard2).
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
        addDice: (FixedDice onFace: 8);
        build.
        

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.
	aGame playTurn.
	self
		should: [ aGame playCard: aCard2 by: aSpaceship2 targeting: aSpaceship. ]
		raise: Error
		withMessageText: 'A mercenary cannot hire other spaceships'
		
	

]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfASpaceshipThatUseMercenaryCardWantsToHaveHimselfAsMercenary [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2));
        build.

    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries isEmpty.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsInvalidIfSpaceshipCanPlayTwiceTheMercenaryCard [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard aSecondCard |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSecondCard := SpeedCard new.
    
    "La nave arranca con 2 cartas"
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 5));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.

    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHasASpaceshipThatHeSpecifiesAsMercenary [ 
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: (SpeedCard new)).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 4 "|Batallan|" "Tira la nave 3 ->"6 "Tira la nave 1 y su mercenaria ->"2 7));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.

    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries 
         equals: (OrderedCollection with: aSpaceship2).

    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 4.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 2.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfASpaceshipThatUseMercenaryCardHastwoSpaceshipsThatHeSpecifiesAsMercenaries [ 
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard1 aCard2 |
    
    aGameBuilder := GameBuilder new.
    "Importante: si la nave tiene dos cartas, suelen ser dos instancias distintas"
    aCard1 := MercenaryCard new.
    aCard2 := MercenaryCard new.
    
    aSpaceship := Spaceship with: (OrderedCollection with: aCard1 with: aCard2).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 6 6 10 4));
        build.

    "--- Acción: Jugar las cartas (No mueven las naves) ---"
    aGame playCard: aCard1 by: aSpaceship targeting: aSpaceship2.
    aGame playCard: aCard2 by: aSpaceship targeting: aSpaceship3.

    self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 2.
    self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship2).
    self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship3).

    aGame playTurn. aGame playTurn. aGame playTurn.
    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 10.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 12.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 10.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfNoBattleOccursWhenSpaceshipAndMercenaryLandOnSameTile [ 
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: SpeedCard new).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 2 3 2 4 10));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.

    aGame playTurn. aGame playTurn. aGame playTurn.
    aGame playTurn. aGame playTurn. aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 6.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 6.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 3.
    self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 3.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipAndMercenaryWinsWhenSpaceshipOrMercenaryHasHighestDice [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard |
    
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 5 1 7));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.
    aGame playTurn. aGame playTurn. aGame playTurn.
	"Batallan, spaceship3 saca un 5 mientras que una de las otras dos saca un 7"

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 4.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 19.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 3.
    self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 3.
    self assert: (aGame spaceshipMatching: aSpaceship3) getShields equals: 2.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.
]

{ #category : 'tests' }
MercenaryCardTest >> testIsValidIfSpaceshipCanPlayAnotherCardHavingAMercenary [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard aSecondCard |
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSecondCard := AccelerationCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard with: aSecondCard).
    aSpaceship2 := Spaceship new. 
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 9));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.
    aGame playCard: aSecondCard by: aSpaceship targeting: aSpaceship.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 0.
    
    aGame playTurn. aGame playTurn. aGame playTurn.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 5.
	 self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 10.
]

{ #category : 'tests' }
MercenaryCardTest >> testWhenASpaceshipAndHisMercenaryLoseABattleThenBothLoseAShield [
    | aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aGame aCard |
    aGameBuilder := GameBuilder new.
    aCard := MercenaryCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aCard).
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 49 to: 67);
        addDice: (SequentialFixedDice onFaces: #(4 19 4 10 1 1));
        build.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.
    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 2.
    self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 2.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 0.
]
