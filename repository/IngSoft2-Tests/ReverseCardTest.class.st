Class {
	#name : 'ReverseCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'id1',
		'id2',
		'id3',
		'id4',
		'aGameBuilder',
		'aReverseCard'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
ReverseCardTest >> setUp [
	super setUp.

	id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'. id4 := 'nave4'.
	aGameBuilder := GameBuilder new.
	aReverseCard := ReverseCard new.
]

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardFromMiddleSpaceshipThenTurnOrderIsInverted [
    | aSpaceship1 aSpaceship2 aSpaceship3 aSpaceship4 aSpaceship5 aGame aBoard  |
    aSpaceship1 := Spaceship with: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: (OrderedCollection with: aReverseCard) and: id3.
    aSpaceship4 := Spaceship with: id4.
    aSpaceship5 := Spaceship with: 'nave5'.
    aBoard := Board withSize: 90 andWormholeFrom: 70 to: 72.
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addSpaceship: aSpaceship4;
                 addSpaceship: aSpaceship5;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(3 4 5 6 7));
                 build.
    2 timesRepeat: [ aGame playTurn ].
    aGame play: ReverseCard by: id3 affecting: nil targeting: nil.
	 2 timesRepeat: [ aGame playTurn ].
    aGame playTurn.
	 self assert: ((aGame spaceshipMatchWith: id3) isAt: 5 and: 0).
    self assert: ((aGame spaceshipMatchWith: id2) isAt: 10 and: 0).
    self assert: ((aGame spaceshipMatchWith: id4) isAt: 0 and: 0).
]

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardThenTurnOrderIsInverted [
    | aSpaceship1 aSpaceship2 aSpaceship3  finishLine aGame aBoard|
    aSpaceship1 := Spaceship with: (OrderedCollection with: aReverseCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.
    finishLine := 90.
    aBoard := Board withSize: 90 andWormholeFrom: 70 to: 72.
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

	| aSpaceship1 aSpaceship2 aSpaceship3 aGame aBoard |
	aSpaceship1 := Spaceship
		               with: (OrderedCollection with: aReverseCard)
		               and: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	aBoard := Board withSize: 90 andWormholeFrom: 70 to: 72.
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


	aGame play: ReverseCard by: id1 affecting: nil targeting: nil.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 12 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 13 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).
]

{ #category : 'tests' }
ReverseCardTest >> testWhenUsingAReverseCardTwiceThenTurnOrderIsRestoredToNormal [
    | aSpaceship1 aSpaceship2 aSpaceship3 finishLine aGame aBoard aReverseCard2|
    aReverseCard2 := ReverseCard new.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aReverseCard) and: id1.
    aSpaceship2 := Spaceship with: (OrderedCollection with: aReverseCard2) and: id2.
    aSpaceship3 := Spaceship with: id3.
    finishLine := 90.
    aBoard := Board withSize: 90 andWormholeFrom: 70 to: 72.
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
