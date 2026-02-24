Class {
	#name : 'PositionTableTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
PositionTableTest >> compareValues: spaceshipsPositions with: expectedPositions [
    ^ spaceshipsPositions = expectedPositions
]

{ #category : 'asserting' }
PositionTableTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
PositionTableTest >> testCannotGetPositionTableBeforeGameIsFinished [

	| aGame aSpaceship aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 10);
		         build.

	aGame playTurn.
	self
		should: [ aGame getPositionTable ]
		raise: Error
		withMessageText:
		'Cannot get position table before game ends.'
]

{ #category : 'tests' }
PositionTableTest >> testRankingPrioritizesHigherLapOverHigherSquare [
	| aGame aGameBuilder aSpaceship1 aSpaceship2 aSpaceship3 aSpaceship4 finishLine aTileBuilder aBoard ranking  expectedIds|

	aGameBuilder := GameBuilder new.

	aSpaceship1 := Spaceship with: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'.
	aSpaceship3 := Spaceship with: 'nave3'.
	aSpaceship4 := Spaceship with: 'nave4'.

	finishLine := 30.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder addWormholeFrom: 4 to: 15.
	aBoard := Board withSize: finishLine andLapsToWin: 3 and: aTileBuilder build.

	aGame := aGameBuilder
		addSpaceship: aSpaceship1;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addSpaceship: aSpaceship4;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: #(43 29 90 ));
		build.

	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.  
	ranking := (aGame getPositionTable) getRanking.

	expectedIds := { 'nave3'. 'nave1'. 'nave2'. 'nave4' }.
	ranking with: expectedIds do: [ :ship :expectedId |
    self assert: (ship matchesId: expectedId) ].




	
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenThePositionTableCanBeKnown [

	| aGame aSpaceship aSpaceship2 aPositionTable aGameBuilder id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.

	self assert: (aPositionTable isShipWithId: id1 atLap: 1 andSquare: 0).
	"Chequear esto"
	self assert: (aPositionTable isShipWithId: id2 atLap: 0 andSquare: 0).

]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheRankingCanBeKnown [  

	| aGame aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aSpaceship4 expectedIds aPosicionTable aRankingPosition |

	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'.
	aSpaceship3 := Spaceship with: 'nave3'.
	aSpaceship4 := Spaceship with: 'nave4'.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2; 
		         addSpaceship: aSpaceship3;
		         addSpaceship: aSpaceship4;  
		         addBoard: (Board withSize: 40 andWormholeFrom: 4 to: 15);
		         addDice: (SequentialFixedDice onFaces: #(22 4 10 5 20 10 7 1));
		         build.

	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.
	
	aPosicionTable := aGame getPositionTable.
	aRankingPosition := aPosicionTable getRanking.

	expectedIds := { 'nave1'. 'nave2'. 'nave3'. 'nave4' }.
	aRankingPosition with: expectedIds do: [ :ship :expectedId |
    self assert: (ship matchesId: expectedId) ].



	
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerCanBeKnown [

	| aGame aSpaceship aPositionTable aGameBuilder id |
	aGameBuilder := GameBuilder new.
	id := 'nave1'.
	aSpaceship := Spaceship with: id.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.
	self assert: (aPositionTable isWinner: id).


]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerIsNotASpaceshipThatIsNotOnTheFinishLine [

	| aGame aSpaceship aSpaceship2 aPositionTable aGameBuilder id2|
	aGameBuilder := GameBuilder new.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: 'nave1'.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.
	self deny: (aPositionTable isWinner: id2).

]
