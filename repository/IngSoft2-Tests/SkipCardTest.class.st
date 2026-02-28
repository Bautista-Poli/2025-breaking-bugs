Class {
	#name : 'SkipCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SkipCardTest >> testWhenUsingAReverseCardAndASkipCardThenTurnOrderIsInvertedAndCurrentSpaceshipLosesItsTurn [

	| aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aReverseCard aSkipCard id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	aReverseCard := ReverseCard new.
	aSkipCard := SkipCard new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aSpaceship1 := Spaceship with: (OrderedCollection with: aSkipCard) and: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: (OrderedCollection with: aReverseCard) and: id3.
	finishLine := 90.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder addWormholeFrom: 70 to: 72.
	aTileCollection := aTileBuilder build.
	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 1
		          and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #( 5 6 7 5 7 ));
		         build.
		
	3 timesRepeat: [ aGame playTurn ].
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 6 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 7 and: 0).


	aGame play: ReverseCard by: id3 affecting: nil targeting: nil.
	aGame play: SkipCard by: id1 affecting: nil targeting: nil.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 7 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 11 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 12 and: 0).
]

{ #category : 'tests' }
SkipCardTest >> testWhenUsingASkipCardOnLastSpaceshipThenTurnWrapsToFirst [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aSkipCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aSkipCard := SkipCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: (OrderedCollection with: aSkipCard) and: id3.
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
                 addDice: (SequentialFixedDice onFaces: #(3 6 9));
                 build.
    aGame playTurn.
    aGame playTurn. 
    aGame play: SkipCard by: id3 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 12 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
]

{ #category : 'tests' }
SkipCardTest >> testWhenUsingASkipCardThenTargetSpaceshipLosesItsTurn [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aSkipCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aSkipCard := SkipCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aSkipCard) and: id1.
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
                 addDice: (SequentialFixedDice onFaces: #(3 6 9));
                 build.
    aGame playTurn. 
    aGame play: SkipCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 6 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	 self assert: ((aGame spaceshipMatchWith: id1) isAt: 3 and: 0).
]

{ #category : 'tests' }
SkipCardTest >> testWhenUsingTwoSkipCardsThenTwoSpaceshipLoseTheirTurn [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aSkipCard1 aSkipCard2 id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aSkipCard1 := SkipCard new.
    aSkipCard2 := SkipCard new.
    id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aSkipCard1 with: aSkipCard2) and: id1.
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
                 addDice: (SequentialFixedDice onFaces: #(3 6));
                 build.
    aGame playTurn. 
    aGame play: SkipCard by: id1 affecting: nil targeting: nil.
    aGame play: SkipCard by: id1 affecting: nil targeting: nil.
    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
    self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
]
