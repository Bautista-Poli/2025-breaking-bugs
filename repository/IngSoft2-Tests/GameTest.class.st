Class {
	#name : 'GameTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'id3',
		'id4'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameTest >> addFourSpaceshipsNoCards [
	^ aGameBuilder
		addSpaceship: (Spaceship with: id1);
		addSpaceship: (Spaceship with: id2);
		addSpaceship: (Spaceship with: id3);
		addSpaceship: (Spaceship with: id4).
]

{ #category : 'running' }
GameTest >> setUp [

	super setUp.
	aGameBuilder := GameBuilder new.
    id1 := 'nave1'. id2 := 'nave2'. 
    id3 := 'nave3'. id4 := 'nave4'.
	
]

{ #category : 'asserting' }
GameTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
GameTest >> testAllTheEffectsOnGame [
	| aGame  board finishLine tileBuilder tileCollection  |
	
	finishLine := 25.

	tileBuilder := TilesBuilder with: finishLine.
	tileBuilder
		with: AtomicBombEffect new at: 3;
		with: BlackHoleEffect new at: 9;
		with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
		with: (MoonWalkEffect for: 2) at: 19;
		with: HyperSpaceJumpEffect new at: 16.
		
	tileBuilder addWormholeFrom: 4 to: 15.
	tileCollection := tileBuilder build.
	
	board := Board withSize: finishLine andLapsToWin: 1 and: tileCollection.

	aGame := aGameBuilder
		addBoard: board;
		addDice: (SequentialFixedDice onFaces: #(3 9 5 4 10 11 14 4 16)).
	self addFourSpaceshipsNoCards.
	aGame := aGameBuilder build.

	"Ronda 1"
	4 timesRepeat: [ aGame playTurn ].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 11 and: 0).

	"Ronda 2"
	4 timesRepeat: [ aGame playTurn ].
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 20 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 14 and: 0).
	
	self assert: ((aGame spaceshipMatchWith: id1) hasShields: 1).
	self assert: ((aGame spaceshipMatchWith: id2) hasShields: 2).
	self assert: ((aGame spaceshipMatchWith: id3) hasShields: 0).
	self assert: ((aGame spaceshipMatchWith: id4) hasShields: 2).

	
	

]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithCardsAndEffectsAndWinner [
	| aGame aSpaceship1 aSpaceship2 aBoard aSpaceship3 aSpaceship4 finishLine aTileBuilder aTileCollection aPositionTable aSpeedCard aCancelationCard aAccelerationCard aMercenaryCard aSpeedCard2 aCancellationCard2 aAccelerationCard2 aMercenaryCard2 |

	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aCancelationCard := CancelationCard new.
	aAccelerationCard := AccelerationCard new.
	aMercenaryCard := MercenaryCard new.
	aSpeedCard2 := SpeedCard new.
	aCancellationCard2 := CancelationCard new.
	aAccelerationCard2 := AccelerationCard new.
	aMercenaryCard2 := MercenaryCard new.

	aSpaceship1 := Spaceship with: (OrderedCollection with: aSpeedCard with: aMercenaryCard2) and: id1.
	aSpaceship2 := Spaceship with: (OrderedCollection with: aCancelationCard with: aSpeedCard2) and: id2.
	aSpaceship3 := Spaceship with: (OrderedCollection with: aAccelerationCard with: aCancellationCard2) and: id3.
	aSpaceship4 := Spaceship with: (OrderedCollection with: aMercenaryCard with: aAccelerationCard2) and: id4.

	finishLine := 43.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder
		with: BlackHoleEffect new at: 9;
		with: AtomicBombEffect new at: 3;
		with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
		with: (MoonWalkEffect for: 1) at: 19;
		with: HyperSpaceJumpEffect new at: 16.
	aTileBuilder addWormholeFrom: 4 to: 15.

	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: aSpaceship1;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addSpaceship: aSpaceship4;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(2 7 8 14 18 12));
		addDice: (FixedDice onFace: 1);
		build.

	4 timesRepeat:[ aGame playTurn].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 4 and: 0).

	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id4) getShields equals: 2.
	self deny: aGame hasFinished.

	aGame playTurn. aGame playTurn.
	aGame playCard: AccelerationCard by: id3 targeting: nil.
	aGame playTurn. aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 19 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 20 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 8 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 12 and: 0).

	aGame play: CancelationCard by: id2 affecting: AccelerationCard targeting: nil.

	self assert: (aGame spaceshipMatchWith: id3) getCards size equals: 1.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 1.

	aGame playCard: SpeedCard by: id1 targeting: id1.
	4 timesRepeat:[aGame playTurn].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 29 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 35 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 27 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 25 and: 0).

	aGame playTurn. aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 33 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 1).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 27 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 25 and: 0).
	self assert: aGame hasFinished.

	aPositionTable := aGame getPositionTable.
	self assert: (aPositionTable isWinner: id2).
	self deny: (aPositionTable isWinner: id1).
	self deny: (aPositionTable isWinner: id3).
	self deny: (aPositionTable isWinner: id4).
]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithEffectsAndWinner [
    | aGame aBoard aTileBuilder aTileCollection aPositionTable |
    
    aTileBuilder := TilesBuilder with: 25.
    aTileBuilder
        with: BlackHoleEffect new at: 9;
        with: AtomicBombEffect new at: 3;
        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
        with: (MoonWalkEffect for: 1) at: 19.
    aTileBuilder addWormholeFrom: 4 to: 15.
    
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: 25 andLapsToWin: 2 and: aTileCollection.
	 self addFourSpaceshipsNoCards.
    aGame := aGameBuilder
        addBoard: aBoard;
        addDice: (SequentialFixedDice onFaces: #(2 7 8 14 18 100));
        addDice: (FixedDice onFace: 1);
        build.

    4 timesRepeat: [ aGame playTurn ].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 4 and: 0).

	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id4) getShields equals: 2.
	self deny: aGame hasFinished.

	aGame playTurn. aGame playTurn.
	self assert: aGame hasFinished.

	aPositionTable := aGame getPositionTable.
	self assert: (aPositionTable isWinner: id2).
	self deny: (aPositionTable isWinner: id1).
	self deny: (aPositionTable isWinner: id3).
	self deny: (aPositionTable isWinner: id4).

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 19 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 4).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 4 and: 0).
	self assert: ((aGame spaceshipMatchWith: id4) isAt: 3 and: 0).

]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithWinner [
	| aGame aSpaceship1 aSpaceship2 finishLine |
	aSpaceship1 := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	finishLine := 19.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: finishLine andWormholeFrom: 4 to: 15);
		         addDice: (SequentialFixedDice onFaces: #(3 7));
		         addDice: (FixedDice onFace: 1);
		         build.
	aGame playTurn. aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 1).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 8 and: 0).
	self assert: aGame hasFinished.
]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesCertainPosition [
    | aGame aSpaceship |
    aSpaceship := Spaceship with: id1.

    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
        addDice: (FixedDice onFace: 5);
        build.

    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 5 and: 0).

]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesToWormholeEntryThenItEndsInWormholeExitValue [
    | aGame aSpaceship |
    aSpaceship := Spaceship with: id1.
    aGame := aGameBuilder
        addSpaceship: aSpaceship;
        addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
        addDice: (FixedDice onFace: 4);
        build.

    aGame playTurn.
    self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).

]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesToWormholeExitThenItEndsInWormholeEntryValue [

	| aGame aSpaceship |
	aSpaceship := Spaceship with: id1.
	aGame := aGameBuilder
		          addSpaceship: aSpaceship;
		          addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		          addDice: (FixedDice onFace: 9);
		          build.

	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).

]

{ #category : 'tests' }
GameTest >> testRaiseErrorIfATurnWantsToBePlayedWhenTheGameHasAlreadyFinished [

	| aGame aSpaceship |
	aSpaceship := Spaceship with: id1.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	self
		should: [ aGame playTurn. ]
		raise: Error
		withMessageText: 'Cannot play a turn after the game has finished.'
]

{ #category : 'tests' }
GameTest >> testWhenASpaceshipReachesTheFinishLineBeforeTheOtherThenTheGameEnds [
	| aGame aSpaceship1 aSpaceship2 finishLine  |
	aSpaceship1 := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	finishLine := 20.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: finishLine andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: finishLine);
		         build.
	aGame playTurn.
	self assert: aGame hasFinished.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 1).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).

]

{ #category : 'tests' }
GameTest >> testWhenASpaceshipReachesTheFinishLineTheGameEnds [

	| aGame aSpaceship |
	aSpaceship := Spaceship with: id1.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	self assert: aGame hasFinished
]

{ #category : 'tests' }
GameTest >> testWhenGameCreatedItDoesntFinish [

	| aGame  |
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: id1);
		         addBoard: (Board withSize: 6 andWormholeFrom: 2 to: 5);
				   addDice: (FixedDice onFace: 4);
		         build.
	
	self deny: aGame hasFinished
]

{ #category : 'tests' }
GameTest >> testWhenLandingOnAWormholeConnectedToTheFinishLineTheGameDoesntEnds [
	| aGame |
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: id1);
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 20);
		         addDice: (FixedDice onFace: 4);
		         build.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 1).
	self assert: aGame hasFinished.
]

{ #category : 'tests' }
GameTest >> testWhenTheSpaceshipMovesBeyondTheFinishLineTheGameEnds [

	| aGame |
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: id1);
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 25);
		         build.

	aGame playTurn.

	self assert: aGame hasFinished.
]

{ #category : 'tests' }
GameTest >> testWhenTheSpaceshipMovesWithTwoDicesBeyondTheFinishLineTheGameEnds [

	| aGame |
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: id1);
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 11);
					addDice: (FixedDice onFace: 10);
		         build.

	aGame playTurn.

	self assert: aGame hasFinished
]
