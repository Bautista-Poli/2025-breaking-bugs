Class {
	#name : 'RepeatCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterABlackHoleEffectBeingAppliedThenItIsReapplied [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder with: BlackHoleEffect new at: 4.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(4 5));
                 build.

    aGame playTurn. "Cae en 4 -> Black Hole -> Retrocede a 0"
    self assert: ((aGame spaceshipMatchWith: id) isAt: 0 and: 0).

    aGame playTurn. "Mueve a 5"
    self assert: ((aGame spaceshipMatchWith: id) isAt: 5 and: 0).

    aGame playCard: RepeatCard by: id targeting: id.
    "Se reaplica Black Hole: 5 - 4 = 1"
    self assert: ((aGame spaceshipMatchWith: id) isAt: 1 and: 0).
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperJumpEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.

    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 19 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 14 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 9 and: 0).

    aGame playCard: RepeatCard by: id1 targeting: id2.
    "Nave 2 estaba en 14, se le aplica el HyperJump de 30 parsecs (15 casilleros) -> 14 + 15 = 29"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 19 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 29 and: 0).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperSpaceJumpBeingAppliedThenItIsReapplied [

    | aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 |
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id1 := 'nave1'. id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: HyperSpaceJumpEffect new
                        at: 4.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(4 2));
                 build.

    aGame playTurn. aGame playTurn.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 8 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 2 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 2).

    aGame playCard: RepeatCard by: id1 targeting: id1.
    "Reaplica HyperSpaceJump: Salta 4 y pierde 1 escudo -> Pos 12, Escudos 1"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 12 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 1).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAMoonWalkEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (MoonWalkEffect for: 3)
                        at: 9.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(7 8 9));
                 build.

    3 timesRepeat: [ aGame playTurn ].

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 9 and: 0).

    aGame playCard: RepeatCard by: id1 targeting: id1.
    "Todas las naves (menos la víctima id1) retroceden 3"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 2 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 6 and: 0).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAnAtomicBombEffectBeingAppliedThenItIsReapplied [

    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: AtomicBombEffect new
                        at: 6.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(4 5 6 7 8 9));
                 build.

    3 timesRepeat: [ aGame playTurn ].
    "Bomba Atómica en turno 3: todos a 0 y pierden escudo"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
    
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 2).

    3 timesRepeat: [ aGame playTurn ]. "Mueven a 7, 8 y 9"

    aGame playCard: RepeatCard by: id1 targeting: id2.
    "Reaplica Bomba: todos a 0 y pierden otro escudo"
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasShields: 1).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterLandingOnANoEffectTileThenNothingHappens [
    | aSpaceship1 aSpaceship2 aGameBuilder aGame aBoard aRepeatCard id1 id2 |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id1 := 'nave1'. id2 := 'nave2'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    aBoard := Board withSize: 90 andWormholeFrom: 80 to: 89.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 5);
                 build.

    aGame playTurn. aGame playTurn.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
    aGame playCard: RepeatCard by: id1 targeting: id2.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardBeforeAnyMoveThenNothingHappens [
    | aSpaceship aGameBuilder aGame aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: 5);
                 build.

    aGame playCard: RepeatCard by: id targeting: id.

    self assert: ((aGame spaceshipMatchWith: id) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardHavingNotHavingAppliedAnEffectThenNothingHappens [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.

    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).

    aGame playCard: RepeatCard by: id targeting: id.

    self assert: ((aGame spaceshipMatchWith: id) isAt: 4 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

]
