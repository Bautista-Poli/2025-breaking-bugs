Class {
	#name : 'ObtainCardTestNP',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ObtainCardTestNP >> testIsValidIfSpaceshipCanUseASpeedCardReceivedByTheTile [
    | aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard |
    
    aGameBuilder := GameBuilder new.
    aSpaceship := Spaceship new.
    aSpaceship2 := Spaceship new.
    aSpaceship3 := Spaceship new.
    
    position := 6.
    aTileBuilder := TilesBuilder with: 60.
    aCard := SpeedCard new.
    

    aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
    aTileCollection := aTileBuilder build.
    
    aBoard := Board withSize: 60 andWormholeFrom: 40 to: 45 and: aTileCollection.
    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: aBoard;
        setLapsToWinTo: 2;
        addDice: (FixedDice onFace: position);
        build.


    aGame playRound. 
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 3.

    aGame playCard: aCard by: aSpaceship targeting: aSpaceship.
    aGame playRound.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 13.
    
    self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
]
