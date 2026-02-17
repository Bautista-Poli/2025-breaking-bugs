Class {
	#name : 'AtomicBombTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
AtomicBombTest >> testWhenSpaceshipLandsOnAtomicBombThenAllSpaceshipsGoTo1PositionAndLoseAShield [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aSpaceship3 aTileBuilder aTileCollection |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship with: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'.
	aSpaceship3 := Spaceship with: 'nave3'.
	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (AtomicBombEffect new) at: 4.
	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andWormholeFrom: 8 to: 15 andLapsToWin: 1 and: aTileCollection .

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
					addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(4 5 6));
		         build.
		
	aGame playTurn. aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatching: aSpaceship)getPosition equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship2)getPosition equals: 5.
	self assert: (aGame spaceshipMatching: aSpaceship3)getPosition equals: 6.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship3) getShields equals: 2.
	
]
