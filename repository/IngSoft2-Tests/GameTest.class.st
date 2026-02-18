Class {
	#name : 'GameTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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
	| aGame aSpaceship1 aSpaceship2 aSpaceship3 aSpaceship4 board aGameBuilder finishLine tileBuilder tileCollection id1 id2 id3 id4 |
	"board con laps 2"
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	id4 := 'nave4'.

	aSpaceship1 := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	aSpaceship4 := Spaceship with: id4.
	finishLine := 25.

	tileBuilder := TilesBuilder with: finishLine.
	tileBuilder
		with: AtomicBombEffect new at: 3;
		with: BlackHoleEffect new at: 9;
		with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
		with: (MoonWalkEffect for: 2) at: 19;
		with: HyperSpaceJumpEffect new at: 16.

	tileCollection := tileBuilder build.
	"ndWormholeFrom: 4 to: 15"
	board := Board withSize: finishLine andLapsToWin: 1 and: tileCollection.

	aGame := aGameBuilder
		addSpaceship: aSpaceship1; addSpaceship: aSpaceship2; addSpaceship: aSpaceship3; addSpaceship: aSpaceship4;
		addBoard: board;
		addDice: (SequentialFixedDice onFaces: #(3 9 5 4 10 11 14 4 16));
		build.

	"Ronda 1"
	aGame playTurn. aGame playTurn. aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 5.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 11.

	"Ronda 2"
	aGame playTurn. aGame playTurn. aGame playTurn. aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 5.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 20.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 14.
	
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 1.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 0.
	self assert: (aGame spaceshipMatchWith: id4) getShields equals: 2.

	
	

]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithCardsAndEffectsAndWinner [
	| aGame aSpaceship1 aSpaceship2 aBoard aGameBuilder finishLine aSpaceship3 aSpaceship4 aTileBuilder aTileCollection aPositionTable aSpeedCard aCancellationCard aAccelerationCard aMercenaryCard aSpeedCard2 aCancellationCard2 aAccelerationCard2 aMercenaryCard2 id1 id2 id3 id4 |

	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aCancellationCard := CancelationCard new.
	aAccelerationCard := AccelerationCard new.
	aMercenaryCard := MercenaryCard new.
	aSpeedCard2 := SpeedCard new.
	aCancellationCard2 := CancelationCard new.
	aAccelerationCard2 := AccelerationCard new.
	aMercenaryCard2 := MercenaryCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	id4 := 'nave4'.

	aSpaceship1 := Spaceship with: (OrderedCollection with: aSpeedCard with: aMercenaryCard2) and: id1.
	aSpaceship2 := Spaceship with: (OrderedCollection with: aCancellationCard with: aSpeedCard2) and: id2.
	aSpaceship3 := Spaceship with: (OrderedCollection with: aAccelerationCard with: aCancellationCard2) and: id3.
	aSpaceship4 := Spaceship with: (OrderedCollection with: aMercenaryCard with: aAccelerationCard2) and: id4.

	finishLine := 43.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder
		with: BlackHoleEffect new at: 9;
		with: AtomicBombEffect new at: 3;
		with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
		with: (MoonWalkEffect for: 1) at: 19;
		with: HyperSpaceJumpEffect new at: 16;
		with: (WormholeEffect targeting: 4) at: 15;
		with: (WormholeEffect targeting: 15) at: 4.

	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andLapsToWin: 1  and: aTileCollection.
		
	aGame := aGameBuilder
		addSpaceship: aSpaceship1;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addSpaceship: aSpaceship4;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(2 7 8 14 18 12));
		addDice: (FixedDice onFace: 1);
		build.

	aGame playTurn. aGame playTurn. aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 5.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 4.
	
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id4) getShields equals: 2.
	self deny: aGame hasFinished.
	
	aGame playTurn.
	aGame playTurn.
	aGame playCard: aAccelerationCard by: id3 targeting: nil.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 20.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 12.
	
	
	aGame play: aCancellationCard by: id2 affecting: aAccelerationCard targeting: nil.
	
	self assert: (aGame spaceshipMatchWith: id3) getCards size equals: 1.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 1.

	aGame playCard: aSpeedCard by: id1 targeting: id1.
	aGame playTurn. aGame playTurn. aGame playTurn. aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 29.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 35.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 27.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 25.
	

	aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 33.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: finishLine.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 27.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 25.

	self assert: aGame hasFinished.
	aPositionTable := aGame getPositionTable.
	self assert: (aPositionTable isWinner: id2).
	self deny: (aPositionTable isWinner: id1).
	self deny: (aPositionTable isWinner: id3).
	self deny: (aPositionTable isWinner: id4).

]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithEffectsAndWinner [

	| aGame aSpaceship1 aSpaceship2 aBoard aGameBuilder finishLine aSpaceship3 aSpaceship4 aTileBuilder aTileCollection aPositionTable id1 id2 id3 id4 |
	"board con laps 2"
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	id4 := 'nave4'.

	aSpaceship1 := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	aSpaceship4 := Spaceship with: id4.
	
	finishLine := 25.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder
		with: BlackHoleEffect new at: 9;
		with: AtomicBombEffect new at: 3;
		with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10) at: 10;
		with: (MoonWalkEffect for: 1) at: 19;
		with: HyperSpaceJumpEffect new at: 16;
		with: (WormholeEffect targeting: 15) at: 4;
		with: (WormholeEffect targeting: 4) at: 15.

	aTileCollection := aTileBuilder build.
	"andWormholeFrom: 4 to: 15"
	aBoard := Board
		          withSize: finishLine
		          andLapsToWin: 2
		          and: aTileCollection.
		
	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addSpaceship: aSpaceship4;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(2 7 8 14 18 100));
		         addDice: (FixedDice onFace: 1);
		         build.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 5.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 4.
	
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
	
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: finishLine.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 4.
	self assert: (aGame spaceshipMatchWith: id4) getPosition equals: 3.

]

{ #category : 'tests' }
GameTest >> testFullGameSimulationWithWinner [

	| aGame aSpaceship1 aSpaceship2 aGameBuilder finishLine id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
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

	aGame playTurn. aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: finishLine.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 8.
	self assert: aGame hasFinished.

]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesCertainPosition [

	| aGame aSpaceship aGameBuilder id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 5);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 5.

]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesToWormholeEntryThenItEndsInWormholeExitValue [

	| aGame aSpaceship aGameBuilder id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 9.

]

{ #category : 'tests' }
GameTest >> testIsValidIfASpacehipMovesToWormholeExitThenItEndsInWormholeEntryValue [

	| aGame aSpaceship aGameBuilder id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 9);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 4.

]

{ #category : 'tests' }
GameTest >> testRaiseErrorIfATurnWantsToBePlayedWhenTheGameHasAlreadyFinished [

	| aGame aSpaceship aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
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

	| aGame aSpaceship1 aSpaceship2 aGameBuilder finishLine id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
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
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: finishLine.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 0.

]

{ #category : 'tests' }
GameTest >> testWhenASpaceshipReachesTheFinishLineTheGameEnds [

	| aGame aSpaceship aGameBuilder |
	

	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
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

	| aGame  aGameBuilder |
	
	aGameBuilder := GameBuilder new.
	aGame := aGameBuilder
		         addSpaceship: (Spaceship with: 'nave1');
		         addBoard: (Board withSize: 6 andWormholeFrom: 2 to: 5);
				   addDice: (FixedDice onFace: 4);
		         build.
	
	self deny: aGame hasFinished
]

{ #category : 'tests' }
GameTest >> testWhenLandingOnAWormholeConnectedToTheFinishLineTheGameDoesntEnds [

		| aGame aSpaceship aGameBuilder id|
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 20);
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id) getPosition equals: 20.
	self deny: aGame hasFinished.
	aGame playTurn.
	self assert: aGame hasFinished
]

{ #category : 'tests' }
GameTest >> testWhenTheSpaceshipMovesBeyondTheFinishLineTheGameEnds [

	| aGame aSpaceship aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 25);
		         build.

	aGame playTurn.

	self assert: aGame hasFinished.
]

{ #category : 'tests' }
GameTest >> testWhenTheSpaceshipMovesWithTwoDicesBeyondTheFinishLineTheGameEnds [

	| aGame aSpaceship aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
					addDice: (FixedDice onFace: 11);
					addDice: (FixedDice onFace: 10);
		         build.

	aGame playTurn.

	self assert: aGame hasFinished
]
