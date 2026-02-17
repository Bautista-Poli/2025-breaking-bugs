Class {
	#name : 'RedoCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingACancellationCardThenTheFirstActivePermanentCardIsCancelled [
    | aGame aSpaceship aGameBuilder position1 aSpeedCard aRedoCard anotherSpeedCard aCollectionOfCards aCancellationCard id |
    position1 := 6.
    aGameBuilder := GameBuilder new.
    aSpeedCard := SpeedCard new.
    anotherSpeedCard := SpeedCard new.
    aCancellationCard := CancelationCard new.
    aRedoCard := RedoCard new.
    aCollectionOfCards := (OrderedCollection with: aSpeedCard with: aRedoCard with: aCancellationCard with: anotherSpeedCard).

    id := 'nave1'.
    aSpaceship := Spaceship with: aCollectionOfCards and: id.
        
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (FixedDice onFace: position1);
        build.

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playCard: anotherSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame play: aCancellationCard by: aSpaceship affecting: aSpeedCard targeting: nil.
    aGame play: aRedoCard by: aSpaceship affecting: anotherSpeedCard targeting: nil.

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

    aGame playCard: aMercenaryCard by: aSpaceship targeting: aSpaceship2.
    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship3.

    self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries includes: (aGame spaceshipMatchWith: id2)).
    self assert: ((aGame spaceshipMatchWith: id1) getMercenaries includes: (aGame spaceshipMatchWith: id3)).

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

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    aGame playCard: anotherRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 33.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.


]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingARepeatReappliesLastTileEffectOnTarget [
    | gameBuilder board titleBuilder dice spaceship1 spaceship2 spaceship3 repeatCard redoCard game id1 id2 id3 |

    repeatCard := RepeatCard new.
    redoCard := RedoCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    spaceship1 := Spaceship with: (OrderedCollection with: repeatCard with: redoCard) and: id1.
    spaceship2 := Spaceship with: id2.
    spaceship3 := Spaceship with: id3.

    titleBuilder := ((TilesBuilder with: 90)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4) build.
    board := Board withSize: 90 andWormholeFrom: 80 to: 89 and: titleBuilder.

    dice := FixedDice onFace: 4.
    gameBuilder := GameBuilder new.
    game := gameBuilder
                addSpaceship: spaceship1;
                addSpaceship: spaceship2;
                addSpaceship: spaceship3;
                addBoard: board;
                addDice: dice;
                build.

    game playTurn. game playTurn. game playTurn.

    self assert: (game spaceshipMatchWith: id1) getPosition equals: 19.
    self assert: (game spaceshipMatchWith: id2) getPosition equals: 14.
    self assert: (game spaceshipMatchWith: id3) getPosition equals: 9.

    game playCard: repeatCard by: spaceship1 targeting: spaceship2.

    self assert: (game spaceshipMatchWith: id2) getPosition equals: 29.

    game playCard: redoCard by: spaceship1 targeting: spaceship2.

    self assert: (game spaceshipMatchWith: id1) getPosition equals: 19.
    self assert: (game spaceshipMatchWith: id2) getPosition equals: 39.
    self assert: (game spaceshipMatchWith: id3) getPosition equals: 9.

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

    aGame playCard: aSpeedCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.

    aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship.
    aGame playTurn.
    aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 23.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

]

{ #category : 'tests' }
RedoCardTest >> testWhenUsingARedoCardAfterUsingAnAccelerationCardThenAllSpaceshipsDoubleItsSpeed [
    | aGame aSpaceship aSpaceship2 aGameBuilder position1 position2 anAccelerationCard aRedoCard id1 id2 |
    position1 := 6.
    position2 := 4.
    aGameBuilder := GameBuilder new.
    anAccelerationCard := AccelerationCard new.
    aRedoCard := RedoCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.

    aSpaceship := Spaceship with: (OrderedCollection with: anAccelerationCard with: aRedoCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addSpaceship: aSpaceship2;
        addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
        addDice: (SequentialFixedDice onFaces: { position1. position2 });
        build.

    aGame playCard: anAccelerationCard by: aSpaceship targeting: nil.
    aGame playTurn. aGame playTurn.
    aGame playCard: aRedoCard by: aSpaceship targeting: nil.
    aGame playTurn. aGame playTurn.
    aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 23.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 17.

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

    aGame playCard: aRedoCard by: aSpaceship targeting: nil.

    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

]
