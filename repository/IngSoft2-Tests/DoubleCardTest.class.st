Class {
	#name : 'DoubleCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
DoubleCardTest >> testWhenUsingADoubleCardAndASkipCardThenSpaceshipRollsOnce [
    | aSpaceship1 aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aDoubleCard aSkipCard id1 id2 |
    aGameBuilder := GameBuilder new.
    aDoubleCard := DoubleCard new.
    aSkipCard := SkipCard new.
    id1 := 'nave1'. id2 := 'nave2'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aDoubleCard with: aSkipCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(3 6));
                 build.
    aGame play: DoubleCard by: id1 affecting: nil targeting: nil.
    aGame play: SkipCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 3 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).
]

{ #category : 'tests' }
DoubleCardTest >> testWhenUsingADoubleCardAndLandingOnAnEffectTitleThenTheEffectIsAplly [
    | aSpaceship1 aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aDoubleCard id1 id2 |
    aGameBuilder := GameBuilder new.
    aDoubleCard := DoubleCard new.
    id1 := 'nave1'. id2 := 'nave2'.
    aSpaceship1 := Spaceship with: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aDoubleCard) and: id2.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder with: (MoonWalkEffect for: 2) at: 9.
    aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(5 4 5));
                 build.
    aGame playTurn.
	 aGame play: DoubleCard by: id2 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 3 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 9 and: 0).
]

{ #category : 'tests' }
DoubleCardTest >> testWhenUsingADoubleCardThenCurrentSpaceshipRollsTwice [
    | aSpaceship1 aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aDoubleCard id1 id2 |
    aGameBuilder := GameBuilder new.
    aDoubleCard := DoubleCard new.
    id1 := 'nave1'. id2 := 'nave2'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aDoubleCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(3 6 9));
                 build.
    aGame play: DoubleCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
]

{ #category : 'tests' }
DoubleCardTest >> testWhenUsingADoubleCardWithASpeedCardActiveThenBonusIsAppliedTwice [
    | aSpaceship1 aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aDoubleCard aSpeedCard id1 id2 |
    aGameBuilder := GameBuilder new.
    aDoubleCard := DoubleCard new.
    aSpeedCard := SpeedCard new.
    id1 := 'nave1'. id2 := 'nave2'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aSpeedCard with: aDoubleCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder addWormholeFrom: 70 to: 72.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(3 6 9));
                 build.
    aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
    aGame play: DoubleCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 11 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
]
