Class {
	#name : 'AtomicBombTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'id3',
		'spaceship1',
		'spaceship2',
		'spaceship3'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
AtomicBombTest >> setUp [

	super setUp.

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
		
	spaceship1 := Spaceship with: id1.
	spaceship2 := Spaceship with: id2.
	spaceship3 := Spaceship with: id3.
]

{ #category : 'tests' }
AtomicBombTest >> testWhenAtomicBombExplodesAndSpaceshipHasOneShieldThenItLosesItAndAppliesPenalty [
	| aGame tiles |
	
	spaceship1 := Spaceship with: id1. 
	spaceship2 := Spaceship with: id2.
	
	tiles := TilesBuilder with: 20.
	tiles with: AtomicBombEffect new at: 14. 
	tiles addWormholeFrom: 8 to: 15.
	
	aGame := aGameBuilder
		addSpaceship: spaceship1;
		addSpaceship: spaceship2;
		addBoard: (Board withSize: 20 andLapsToWin: 3 and: tiles build);
		"Nave 1 va al 2 (pierde 1 escudo). Nave 2 va al 4 (activa bomba)"
		addDice: (SequentialFixedDice onFaces: #(2 2 6 1 4 2 6 1 "1 escudo"4));
		build.
		
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 1.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 0.

	
]

{ #category : 'tests' }
AtomicBombTest >> testWhenAtomicBombExplodesLapsAreMaintained [
	| aGame tiles |
	
	"Tablero pequeño de 10 casilleros para facilitar el cálculo de vueltas"
	tiles := TilesBuilder with: 20.
	tiles with: AtomicBombEffect new at: 4.
	tiles addWormholeFrom: 8 to: 15.
	
	aGame := aGameBuilder
		addSpaceship: spaceship1;
		addSpaceship: spaceship2;
		addBoard: (Board withSize: 10 andLapsToWin: 3 and: tiles build);
		addDice: (SequentialFixedDice onFaces: #(15 4));
		build.
		
	aGame playTurn.
	aGame playTurn. 
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 1).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 0 and: 0).

	
]

{ #category : 'tests' }
AtomicBombTest >> testWhenSpaceshipLandsOnAtomicBombThenAllSpaceshipsGoTo1PositionAndLoseAShield [

	| finishLine aGame aBoard aTileBuilder aTileCollection |
	
	spaceship1 := Spaceship with: id1.
	spaceship2 := Spaceship with: id2.
	spaceship3 := Spaceship with: id3.
	
	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (AtomicBombEffect new) at: 4.
	aTileBuilder addWormholeFrom: 8 to: 15.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: spaceship1 ;
		         addSpaceship: spaceship2;
		         addSpaceship: spaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(4 5 6));
		         build.
		
	aGame playTurn. aGame playTurn. aGame playTurn.
	self assert: ((aGame spaceshipMatchWith: id1) isAt: 0 and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 5 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 6 and: 0).
	
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.

	
]
