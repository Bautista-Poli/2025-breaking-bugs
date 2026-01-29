Class {
	#name : 'MercenaryCardTestNP',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
MercenaryCardTestNP >> testIsInvalidIfSpaceshipCanPlayTwiceTheMercenaryCard [
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
MercenaryCardTestNP >> testIsValidIfASpaceshipThatUseMercenaryCardHasASpaceshipThatHeSpecifiesAsMercenary [ 
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

    aGame playRound.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 4.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 2.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.
]

{ #category : 'tests' }
MercenaryCardTestNP >> testIsValidIfASpaceshipThatUseMercenaryCardHastwoSpaceshipsThatHeSpecifiesAsMercenaries [ 
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

    aGame playRound. 
    aGame playRound.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 10.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 12.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 10.
]
