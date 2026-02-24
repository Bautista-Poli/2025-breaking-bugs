Class {
	#name : 'RedoCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingACancellationCardThenTheFirstActivePermanentCardIsCancelled [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherSpeedCard aCollectionOfCards aCancelationCard id |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    anotherSpeedCard := SpeedCard new.
    aCancelationCard := CancelationCard new.
    aRedoCard := RedoCard new.
    aCollectionOfCards := (OrderedCollection with: aSpeedCard with: aRedoCard with: aCancelationCard with: anotherSpeedCard).

    id := 'nave1'.
    aSpaceship := Spaceship with: aCollectionOfCards and: id.
        
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: SpeedCard by: id targeting: id.
    aGame playCard: SpeedCard by: id targeting: id.
    aGame play: CancelationCard by: id affecting: SpeedCard targeting: nil.
    aGame play: RedoCard by: id affecting: SpeedCard targeting: nil.

    aGame playTurn.

    self assert: aGame activePermanentCards isEmpty.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAMercenaryCardThenTheSpaceshipHas2Mercenaries [
    | aGame aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position1 aMercenaryCard aRedoCard id1 id2 id3 |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aMercenaryCard := MercenaryCard new.
    aRedoCard := RedoCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship := Spaceship with: (OrderedCollection with: aMercenaryCard with: aRedoCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addSpaceship: aSpaceship3;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: MercenaryCard by: id1 targeting: id2.
    aGame playCard: RedoCard by: id1 targeting: id3.

    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matchesId: id2 ]).
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matchesId: id3 ]).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARedoCardThenTheFirstEffectIsReapplied [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherRedoCard id |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    anotherRedoCard := RedoCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard with: anotherRedoCard) and: id.
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: SpeedCard by: id targeting: id. "Speed +1"
    aGame playTurn. "6 + 1 = 7"

    aGame playCard: RedoCard by: id targeting: id. 
    aGame playTurn.

    aGame playCard: RedoCard by: id targeting: id. 
    aGame playTurn. 

    aGame playTurn.
    
    self assert: ((aGame spaceshipMatchWith: id) isAt: 33 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARepeatReappliesLastTileEffectOnTarget [
    | gameBuilder board titleBuilder tile dice spaceship1 spaceship2 spaceship3 repeatCard redoCard game id1 id2 id3 |

    repeatCard := RepeatCard new.
    redoCard := RedoCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.

    spaceship1 := Spaceship with: (OrderedCollection with: repeatCard with: redoCard) and: id1.
    spaceship2 := Spaceship with: id2.
    spaceship3 := Spaceship with: id3.

    titleBuilder := ((TilesBuilder with: 90)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4). 
     tile :=  titleBuilder addWormholeFrom: 40 to: 49; build.

    board := Board withSize: 180 andLapsToWin: 1 and: tile.
    dice := FixedDice onFace: 4.
    gameBuilder := GameBuilder new.
    game := gameBuilder
                addSpaceship: spaceship1;
                addSpaceship: spaceship2;
                addSpaceship: spaceship3;
                addBoard: board;
                addDice: dice;
                build.

    3 timesRepeat: [ game playTurn ].

    self assert: ((game spaceshipMatchWith: id1) isAt: 19 and: 0).
    self assert: ((game spaceshipMatchWith: id2) isAt: 14 and: 0).
    self assert: ((game spaceshipMatchWith: id3) isAt: 9 and: 0).

    game playCard: RepeatCard by: id1 targeting: id2. 
    self assert: ((game spaceshipMatchWith: id2) isAt: 29 and: 0).

    game playCard: RedoCard by: id1 targeting: id2.
    self assert: ((game spaceshipMatchWith: id1) isAt: 19 and: 0).
    self assert: ((game spaceshipMatchWith: id2) isAt: 39 and: 0).
    self assert: ((game spaceshipMatchWith: id3) isAt: 9 and: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingASpeedCardThenTheSpaceshipDoublesItsSpeed [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard id |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard) and: id.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: SpeedCard by: id targeting: id.
    aGame playTurn. 

    aGame playCard: RedoCard by: id targeting: id.
    aGame playTurn. 
    aGame playTurn. 

    self assert: ((aGame spaceshipMatchWith: id) isAt: 23 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAnAccelerationCardThenAllSpaceshipsDoubleItsSpeed [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 anAccelerationCard aRedoCard id1 id2 |
    position1 := 6. position2 := 4.
    aGameBuilder := GameBuilder new.
    anAccelerationCard := AccelerationCard new.
    aRedoCard := RedoCard new.

    id1 := 'nave1'. id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: anAccelerationCard with: aRedoCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

    aGame playCard: AccelerationCard by: id1 targeting: nil.
    aGame playTurn. "6+1 = 7"
    aGame playTurn. "4+1 = 5"
    
    aGame playCard: RedoCard by: id1 targeting: nil. "Ahora hay +2 de aceleración global"
    
    aGame playTurn. "7 + (6+2) = 15"
    aGame playTurn. "5 + (4+2) = 11"
    aGame playTurn. "15 + (6+2) = 23"
    aGame playTurn. "11 + (4+2) = 17"

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 23 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 17 and: 0).
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardHavingNotUsedOtherBeforeThenNothingHappens [
    | aGame aSpaceship aGameBuilder position1 aRedoCard id |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aRedoCard := RedoCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRedoCard) and: id.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: position1);
                 build.

    aGame playCard: RedoCard by: id targeting: nil.

    self assert: ((aGame spaceshipMatchWith: id) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id) hasCardsAmount: 0).

]
