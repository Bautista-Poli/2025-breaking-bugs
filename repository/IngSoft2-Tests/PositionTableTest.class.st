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
	aSpaceship := Spaceship new.
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

	| aGame aFirstSpaceship aSecondSpaceship aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aFirstSpaceship := Spaceship new.
	aSecondSpaceship := Spaceship new.

	aGame := aGameBuilder
		         addSpaceship: aFirstSpaceship;
		         addSpaceship: aSecondSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := aGame getPositionTable.

	self assert: (aPositionTable isShip: aFirstSpaceship atLap: 1 andSquare: 20).
	"Chequear esto"
	self assert: (aPositionTable isShip: aSecondSpaceship atLap: 0 andSquare: 0)
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheRankingCanBeKnown [ 

	| aGame aSecondSpaceship  aGameBuilder aFirstSpaceship aThirdSpaceship expectedRanking aPosicionTable aRankingPosition aFourthSpaceship |
	aGameBuilder := GameBuilder new.
	aFirstSpaceship := Spaceship new.
	aSecondSpaceship := Spaceship new.
	aThirdSpaceship := Spaceship new.
	aFourthSpaceship := Spaceship new.
	aGame := aGameBuilder
		         addSpaceship: aFirstSpaceship;
					addSpaceship: aSecondSpaceship; 
					addSpaceship: aThirdSpaceship;
					addSpaceship: aFourthSpaceship ; 
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 15 andLapsToWin: 2);
		         addDice: (SequentialFixedDice onFaces: #(22 4 10 5 20 10 7 1));
		         build.

	aGame playTurn.  aGame playTurn.  aGame playTurn.  aGame playTurn. 
	aGame playTurn. 
	
	aPosicionTable := (aGame getPositionTable ).
	
	aRankingPosition := aPosicionTable getRanking.
	expectedRanking := { aFirstSpaceship. aSecondSpaceship. aThirdSpaceship. aFourthSpaceship }.

	
	self assert: aRankingPosition size equals: expectedRanking size.
	1 to: aRankingPosition size do: [ :i |
		self assert: (aRankingPosition at: i) equals: (expectedRanking at: i) ].


	
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerCanBeKnown [

	| aGame aSpaceship aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship new.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := (aGame getPositionTable).
	self assert: (aPositionTable isWinner: aSpaceship)
]

{ #category : 'tests' }
PositionTableTest >> testWhenGameEndsThenTheWinnerIsNotASpaceshipThatIsNotOnTheFinishLine [

	| aGame aSecondSpaceship aPositionTable aGameBuilder |
	aGameBuilder := GameBuilder new.
	aSecondSpaceship := Spaceship new.
	aGame := aGameBuilder
		         addSpaceship: Spaceship new;
					addSpaceship: aSecondSpaceship; 
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (FixedDice onFace: 20);
		         build.

	aGame playTurn.
	aPositionTable := (aGame getPositionTable).
	self deny: (aPositionTable isWinner: aSecondSpaceship).
]
