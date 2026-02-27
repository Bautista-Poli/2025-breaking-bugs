Class {
	#name : 'ReverseCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardThenTurnOrderIsInverted [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aReverseCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aReverseCard := ReverseCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aReverseCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
	 aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(5 6 7 5 7));
                 build.

    3 timesRepeat: [ aGame playTurn ].
	 self assert: ((aGame spaceshipMatchWith: id3) isAt: 7 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).


    aGame play: ReverseCard by: id1 affecting: nil targeting: nil.
	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 12 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
]

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardThenTurnOrderIsInvertedForMultipleTurns [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aReverseCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aReverseCard := ReverseCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aReverseCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
	 aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(5 6 7 5 7));
                 build.

    3 timesRepeat: [ aGame playTurn ].
	 self assert: ((aGame spaceshipMatchWith: id3) isAt: 7 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).


    aGame play: ReverseCard by: id1 affecting: nil targeting: nil.
	 aGame playTurn.
	 aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 12 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id2) isAt: 13 and: 0).
]

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardTwiceThenTurnOrderIsRestoredToNormal [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aReverseCard1 aReverseCard2 id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aReverseCard1 := ReverseCard new.
    aReverseCard2 := ReverseCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aReverseCard1) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aReverseCard2) and: id2.
    aSpaceship3 := Spaceship with: id3.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(5 6 7 5 7));
                 build.
    3 timesRepeat: [ aGame playTurn ].

    aGame play: ReverseCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 12 and: 0).

    aGame play: ReverseCard by: id2 affecting: nil targeting: nil.
    aGame playTurn.
	 self assert: ((aGame spaceshipMatchWith: id3) isAt: 12 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 13 and: 0).
]
