Class {
	#name : 'ObtainCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseACancelationCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aGameBuilder position position2 aGame aBoard aTileBuilder aTileCollection aSpeedCard aCard |
	
	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new. 
	aCard := CancelationCard new.
	
	aSpaceship := Spaceship new.
	aSpaceship2 := Spaceship with: (OrderedCollection with: aSpeedCard with: aSpeedCard).
	
	position := 6. 
	position2 := 4.
	aTileBuilder := TilesBuilder with: 60.
	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andWormholeFrom: 40 to: 45 andLapsToWin: 2 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: {position. position2});
		build.

	aGame playTurn. 
	aGame playCard: aSpeedCard by: aSpaceship2 targeting: aSpaceship2.
	aGame playTurn. 

	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 3.
	self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: position.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: position2+1.

	aGame play: aCard by: aSpaceship affecting: aSpeedCard targeting: nil.

	aGame playTurn.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: (position * 2).
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: (position2 * 2)+1.
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAMercenaryCardReceivedByTheTitle [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship new.
	aSpaceship2 := Spaceship new.
	aSpaceship3 := Spaceship new.

	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	aCard := MercenaryCard new.

	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: 60
		          andWormholeFrom: 40
		          to: 45
				    andLapsToWin: 2
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: { position. 15 });
		         build.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: position.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 3.

	aGame playCard: aCard by: aSpaceship targeting: aSpaceship2.

	self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
	self assert:((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship2)
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseARedoCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aMercenaryCard aRedoCard |
	
	aGameBuilder := GameBuilder new.
	aMercenaryCard := MercenaryCard new.
	aRedoCard := RedoCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: aMercenaryCard with: MercenaryCard new).
	aSpaceship2 := Spaceship new. 
	aSpaceship3 := Spaceship new.
	
	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	
	aTileBuilder with: (ObtainCardEffect with: aRedoCard) at: position.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andWormholeFrom: 40 to: 45 andLapsToWin: 2 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (FixedDice onFace: position);
		build.
		
	aGame playCard: aMercenaryCard by: aSpaceship targeting: aSpaceship2.
	aGame playTurn. 
	
	self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
	aGame playCard: aRedoCard by: aSpaceship targeting: aSpaceship3.
	
	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship) getMercenaries size equals: 2.
	self assert: ((aGame spaceshipMatching: aSpaceship) getMercenaries includes: aSpaceship3).
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseASpeedCardReceivedByTheTile [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship new.
	aSpaceship2 := Spaceship new.
	aSpaceship3 := Spaceship new.

	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	aCard := SpeedCard new.


	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: 60
		          andWormholeFrom: 40
		          to: 45
		          andLapsToWin: 2
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: position);
		         build.


	aGame playTurn. aGame playTurn. aGame playTurn. 
	self
		assert: (aGame spaceshipMatching: aSpaceship) getCards size
		equals: 3.

	aGame playCard: aCard by: aSpaceship targeting: aSpaceship.
	aGame playTurn. aGame playTurn. aGame playTurn. 
	self
		assert: (aGame spaceshipMatching: aSpaceship) getPosition
		equals: 13.

	self
		assert: (aGame spaceshipMatching: aSpaceship) getCards size
		equals: 2
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAnAccelerationCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard |
	
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship new. 
	aSpaceship2 := Spaceship new. 
	aSpaceship3 := Spaceship new.
	position := 3.
	
	aTileBuilder := TilesBuilder with: 60.
	aCard := AccelerationCard new.
	
	aTileBuilder with: (ObtainCardEffect with: aCard) at: 3.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andWormholeFrom: 40 to: 45 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: {position. 4. 6});
		build.

	aGame playTurn. 
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: position.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 4.
	self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 6.

	aGame playCard: aCard by: aSpaceship targeting: nil.
	aGame playTurn. 
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatching: aSpaceship) getCards size equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship2) getCards size equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: position*2 + 1.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 9.
	self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 13.
	
	
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipReceivesCardWhenLandingOnCardTile [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection |
	aGameBuilder := GameBuilder new.
	aSpaceship := Spaceship new.
	aSpaceship2 := Spaceship new.
	aSpaceship3 := Spaceship new.
	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (ObtainCardEffect new) at: 4.
	aTileCollection := aTileBuilder build.
	aBoard := Board withSize: finishLine andWormholeFrom: 8 to: 15 and: aTileCollection.
	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 4);
		         build.
	aGame playTurn. aGame playTurn. 

	self assert: (aGame spaceshipMatching: aSpaceship)getPosition equals: 4.
	self assert: (aGame spaceshipMatching: aSpaceship)getCards size equals: 3.
	
	
]
