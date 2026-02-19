Class {
	#name : 'ObtainCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseACancelationCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aGameBuilder position position2 aGame aBoard aTileBuilder aTileCollection aSpeedCard aCard id1 id2 |
	
	aGameBuilder := GameBuilder new.
	aSpeedCard := SpeedCard new.
	aCard := CancelationCard new.
	
	id1 := 'nave1'.
	id2 := 'nave2'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: (OrderedCollection with: aSpeedCard with: aSpeedCard) and: id2.
	
	position := 6.
	position2 := 4.
	aTileBuilder := TilesBuilder with: 60.
	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: 60 andLapsToWin: 2 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: { position. position2 });
		build.

	aGame playTurn.
	aGame playCard: aSpeedCard by: id2 targeting: id2.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 3.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 1.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: position.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: position2 + 1.

	aGame play: aCard by: id1 affecting: aSpeedCard targeting: nil.

	aGame playTurn.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: (position * 2).
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: (position2 * 2) + 1.

]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAMercenaryCardReceivedByTheTitle [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	aCard := MercenaryCard new.

	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: 60
		          
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

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: position.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 3.

	aGame playCard: aCard by: id1 targeting: id2.

	self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 1.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.
	self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matches: id2 ]).
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseARedoCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aMercenaryCard aRedoCard id1 id2 id3 |
	
	aGameBuilder := GameBuilder new.
	aMercenaryCard := MercenaryCard new.
	aRedoCard := RedoCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: (OrderedCollection with: aMercenaryCard with: MercenaryCard new) and: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	
	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	
	aTileBuilder with: (ObtainCardEffect with: aRedoCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andLapsToWin: 2 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (FixedDice onFace: position);
		build.
		
	aGame playCard: aMercenaryCard by: id1 targeting: id2.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 1.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.

	aGame playCard: aRedoCard by: id1 targeting: id3.
	
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.
	self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
	self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matches: id2 ]).


]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseASpeedCardReceivedByTheTile [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	position := 6.
	aTileBuilder := TilesBuilder with: 60.
	aCard := SpeedCard new.

	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: 60
		          
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
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 3.

	aGame playCard: aCard by: id1 targeting: id1.
	aGame playTurn. aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 13.

	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.



]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAnAccelerationCardReceivedByTheTitle [
	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder position aGame aBoard aTileBuilder aTileCollection aCard id1 id2 id3 |
	
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	position := 3.
	
	aTileBuilder := TilesBuilder with: 60.
	aCard := AccelerationCard new.
	
	aTileBuilder with: (ObtainCardEffect with: aCard) at: 3.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andLapsToWin: 1 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: { position. 4. 6 });
		build.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: position.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 4.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 6.

	aGame playCard: aCard by: id1 targeting: nil.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getCards size equals: 2.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: position * 2 + 1.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 9.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 13.



]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipReceivesCardWhenLandingOnCardTile [

	| aSpaceship aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileBuilder aTileCollection id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	finishLine := 20.
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder with: (ObtainCardEffect new) at: 4.
	aTileBuilder addWormholeFrom: 9 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (FixedDice onFace: 4);
		         build.

	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 4.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 3.




]
