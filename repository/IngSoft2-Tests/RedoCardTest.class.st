Class {
	#name : 'RedoCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'id3'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
RedoCardTest >> setUp [
	super setUp.

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingACancellationCardThenTheFirstActivePermanentCardIsCancelled [
    | aGame aSpaceship position1 aSpeedCard aRedoCard anotherSpeedCard aCollectionOfCards aCancelationCard  |
    position1 := 6.
    aSpeedCard := SpeedCard new.
    anotherSpeedCard := SpeedCard new.
    aCancelationCard := CancelationCard new.
    aRedoCard := RedoCard new.
    aCollectionOfCards := (OrderedCollection with: aSpeedCard with: aRedoCard with: aCancelationCard with: anotherSpeedCard).

    aSpaceship := Spaceship with: aCollectionOfCards and: id1.
        
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
    aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
    aGame play: CancelationCard by: id1 affecting: SpeedCard targeting: nil.
    aGame play: RedoCard by: id1 affecting: SpeedCard targeting: nil.

    aGame playTurn.

    self deny: (aGame hasActivePermanentCardOfType: SpeedCard).
    self assert: (aGame spaceshipMatchWith: id1) getCards isEmpty.

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAMercenaryCardThenTheSpaceshipHas2Mercenaries [
    | aGame aSpaceship aSpaceship2 aSpaceship3 position1 aMercenaryCard aRedoCard |
    position1 := 6.
    aMercenaryCard := MercenaryCard new.
    aRedoCard := RedoCard new.

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

    aGame play: MercenaryCard by: id1 affecting:nil targeting: id2.
    aGame play: RedoCard by: id1 affecting:nil targeting: id3.

    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matchesId: id2 ]).
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matchesId: id3 ]).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARedoCardThenTheFirstEffectIsReapplied [
    | aGame aSpaceship  position1 aSpeedCard aRedoCard anotherRedoCard |
    position1 := 6.
    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.
    anotherRedoCard := RedoCard new.

    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard with: anotherRedoCard) and: id1.
                                    
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
    aGame playTurn. "6 + 1 = 7"

    aGame play: RedoCard by: id1 affecting:nil targeting: id1.
    aGame playTurn.

    aGame play: RedoCard by: id1 affecting:nil targeting: id1.
    aGame playTurn. 

    aGame playTurn.
    
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 33 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARepeatReappliesLastTileEffectOnTarget [
    | gameBuilder board titleBuilder tile dice spaceship1 spaceship2 spaceship3 repeatCard redoCard game |

    repeatCard := RepeatCard new.
    redoCard := RedoCard new.

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

    game play: RepeatCard by: id1 affecting:nil targeting: id2.
    self assert: ((game spaceshipMatchWith: id2) isAt: 29 and: 0).

    game play: RedoCard by: id1 affecting:nil targeting: id2.
    self assert: ((game spaceshipMatchWith: id1) isAt: 19 and: 0).
    self assert: ((game spaceshipMatchWith: id2) isAt: 39 and: 0).
    self assert: ((game spaceshipMatchWith: id3) isAt: 9 and: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingASpeedCardThenTheSpaceshipDoublesItsSpeed [
    | aGame aSpaceship aSpeedCard aRedoCard |

    aSpeedCard := SpeedCard new.
    aRedoCard := RedoCard new.

    aSpaceship := Spaceship with: (OrderedCollection with: aSpeedCard with: aRedoCard) and: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: 6);
        build.

   aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
    aGame playTurn. 
   aGame play: RedoCard by: id1 affecting:nil targeting: id1.
    
    aGame playTurn. 
    aGame playTurn. 

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 23 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAnAccelerationCardThenAllSpaceshipsDoubleItsSpeed [
    | aGame aSpaceship aSpaceship2 position1 position2 anAccelerationCard aRedoCard  |
    position1 := 6. position2 := 4.
	 anAccelerationCard := AccelerationCard new.
    aRedoCard := RedoCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: anAccelerationCard with: aRedoCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

    aGame play: AccelerationCard by: id1 affecting: nil targeting: nil.
    aGame playTurn. 
    aGame playTurn. 
    
    aGame play: RedoCard by: id1 affecting:nil targeting: nil.
    
    aGame playTurn. 
    aGame playTurn. 
    aGame playTurn. 
    aGame playTurn. 

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 23 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 17 and: 0).
]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardHavingNotUsedOtherBeforeThenNothingHappens [
    | aGame aSpaceship  position1 aRedoCard |
    position1 := 6.

    aRedoCard := RedoCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aRedoCard) and: id1.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: position1);
                 build.

    aGame play: RedoCard by: id1 affecting:nil targeting: nil.

    self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 0).

]
