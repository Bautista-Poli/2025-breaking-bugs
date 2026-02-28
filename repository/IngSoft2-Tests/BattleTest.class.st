Class {
	#name : 'BattleTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BattleTest >> testIsValidIfSpaceshipHasThreeShieldsWhenCreated [

| aSpaceship |
	aSpaceship := Spaceship with: 'nave1'.
	self assert: aSpaceship getShields equals: 3.
]

{ #category : 'tests' }
BattleTest >> testPenalizedSpaceshipMovesAndThenRecoversShieldsAfterSkipTurn [

	| aGameBuilder aSpaceship aSpaceship2 aGame id1 id2 |
	aGameBuilder := GameBuilder new.
	
	id1 := 'nave1'.
	id2 := 'nave2'.
	
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 40 andWormholeFrom: 4 to: 9);
		         addDice: (SequentialFixedDice onFaces: #(4 4 12 14));
		         build.

	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	aGame playTurn.
	aGame skipMyTurn.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).

	
]

{ #category : 'tests' }
BattleTest >> testSpaceshipRecoversAfterTwoPenaltyRoundsAndResumesMovementWithShields [

	| aGameBuilder aSpaceship aSpaceship2 aGame id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aGame := aGameBuilder
		          addSpaceship: aSpaceship;
		          addSpaceship: aSpaceship2;
		          addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		          addDice: (SequentialFixedDice onFaces: #("turn"2 2 "battle"10 12 "turn"1 3 "battle"10 12 "turn"2 5 "battle"10 12 "turn"1 "turn"1 "turn"2 4));
		          build.

	8 timesRepeat: [ aGame playTurn ]. "Llegamos al punto donde se queda sin escudos"
	2 timesRepeat: [ aGame playTurn ]. "Turnos de penalización"

	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	
	aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 9 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.
]

{ #category : 'tests' }
BattleTest >> testSpaceshipRecoversShieldsAfterSkippingTurn [

	| aGameBuilder aSpaceship aSpaceship2 aGame id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (SequentialFixedDice onFaces: #(4 4 12 14));
		         build.

	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	aGame playTurn.
	aGame skipMyTurn.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 3.


]

{ #category : 'tests' }
BattleTest >> testSpaceshipWithNoShieldsCannotMoveDuringPenalty [

	| aGameBuilder aSpaceship aSpaceship2 aGame id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (SequentialFixedDice onFaces: #("turn"2 2 "battle"10 12 "turn"1 3 "battle"10 12 "turn"2 5 "battle"10 12 "turn"4 2));
		         build.

	aGame playTurn. aGame playTurn.
	aGame playTurn. aGame playTurn.
	aGame playTurn. aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 0.

	aGame playTurn. aGame playTurn. "Se queda sin escudos por lo cual no va a poder moverse"
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 0.

	
]

{ #category : 'tests' }
BattleTest >> testSpaceshipsBattleWhenLandingOnSamePositionAndLoserIsPenalized [

	| aGameBuilder aSpaceship aSpaceship2 aGame id1 id2 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		         addDice: (SequentialFixedDice onFaces: #(4 4 12 14));
		         build.

	aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.

]

{ #category : 'tests' }
BattleTest >> testWhenBattleIsTiedThenSpaceshipAlreadyOnTileWins [

	| aGameBuilder aSpaceship aSpaceship2 aSecondOponent aGame id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSecondOponent := Spaceship with: id3.

	aGame := aGameBuilder
		          addSpaceship: aSpaceship;
		          addSpaceship: aSpaceship2;
		          addSpaceship: aSecondOponent;
		          addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		          addDice: (SequentialFixedDice onFaces: #(4 4 4 4));
		          build.

	aGame playTurn. aGame playTurn.
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.

]

{ #category : 'tests' }
BattleTest >> testWhenTwoSpaceshipsLandOnSamePositionThenLoserReturnsToStartAndLosesShield [

	| aGameBuilder aSpaceship aSpaceship2 aSecondOponent aGame id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSecondOponent := Spaceship with: id3.

	aGame := aGameBuilder
		          addSpaceship: aSpaceship;
		          addSpaceship: aSpaceship2;
		          addSpaceship: aSecondOponent;
		          addBoard: (Board withSize: 20 andWormholeFrom: 4 to: 9);
		          addDice: (SequentialFixedDice onFaces: #(4 4 12 14));
		          build.

	aGame playTurn. aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 9 and: 0).
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 3.
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.

]
