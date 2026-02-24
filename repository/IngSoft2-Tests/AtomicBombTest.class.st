Class {
	#name : 'AtomicBombTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
AtomicBombTest >> testWhenSpaceshipLandsOnAtomicBombThenAllSpaceshipsGoTo1PositionAndLoseAShield [

	| aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 id3 aSpaceship aSpaceship2 aSpaceship3 |
	aGameBuilder := GameBuilder new.
	
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.
	
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	
	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (AtomicBombEffect new) at: 4.
	aTileBuilder addWormholeFrom: 8 to: 15.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
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
