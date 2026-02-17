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
PositionTableTest >> testWhenGameEndsThenThePositionTableCanBeKnown [

	| aGame aSpaceship aSpaceship2 aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
   aSpaceship2 := Spaceship with: 'nave2'.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.

	self assert: (aPositionTable isShip: aSpaceship atLap: 1 andSquare: 20).
	"Chequear esto"
	self assert: (aPositionTable isShip: aSpaceship2 atLap: 0 andSquare: 0)
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheRankingCanBeKnown [  

	| aGame aGameBuilder aSpaceship aSpaceship2 aSpaceship3 aSpaceship4 expectedRanking aPosicionTable aRankingPosition |

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
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 15 andLapsToWin: 2);
		         addDice: (SequentialFixedDice onFaces: #(22 4 10 5 20 10 7 1));
		         build.

	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.  
	aGame playTurn.
	
	aPosicionTable := aGame getPositionTable.
	aRankingPosition := aPosicionTable getRanking.

	expectedRanking := { aSpaceship. aSpaceship2. aSpaceship3. aSpaceship4 }.

	self assert: aRankingPosition size equals: expectedRanking size.
	1 to: aRankingPosition size do: [ :i |
		self assert: (aRankingPosition at: i) equals: (expectedRanking at: i) ].



	
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerCanBeKnown [

	| aGame aSpaceship aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.
	self assert: (aPositionTable isWinner: aSpaceship).

]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerIsNotASpaceshipThatIsNotOnTheFinishLine [

	| aGame aSpaceship aSpaceship2 aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.
	self deny: (aPositionTable isWinner: aSpaceship2).

]
