Class {
	#name : 'ObtainCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'aGameBuilder',
		'id1',
		'id2',
		'id3',
		'aSpaceship',
		'aSpaceship2',
		'aSpaceship3',
		'position',
		'aTileBuilder'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
ObtainCardTest >> setUp [
	super setUp.

	aGameBuilder := GameBuilder new.
	id1 := 'nave1'. id2 := 'nave2'. id3 := 'nave3'.
	aSpaceship := Spaceship with: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.
	position := 6.
	aTileBuilder := TilesBuilder with: 60.
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseACancelationCardReceivedByTheTitle [
	| position2 aGame aBoard  aTileCollection aSpeedCard aCard |
	
	aSpeedCard := SpeedCard new.
	aCard := CancelationCard new.
	aSpaceship2 := Spaceship with: (OrderedCollection with: aSpeedCard with: aSpeedCard) and: id2.
	
	position2 := 4.
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
	aGame play: SpeedCard by: id2 affecting: nil targeting: id2.
	aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 3).
	self assert: ((aGame spaceshipMatchWith: id2) hasCardsAmount: 1).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: position and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: (position2 + 1) and: 0).

	aGame play: CancelationCard by: id1 affecting: SpeedCard targeting: nil.

	aGame playTurn. aGame playTurn.
	
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: (position * 2) and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: ((position2 * 2) + 1) and: 0).
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAMercenaryCardReceivedByTheTitle [

	| aGame aBoard aTileCollection aCard |

	aCard := MercenaryCard new.

	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: 60 andLapsToWin: 2 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: { position. 15 });
		build.

	3 timesRepeat: [ aGame playTurn ].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: position and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 3).

	aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.

	self assert: ((aGame spaceshipMatchWith: id1) hasMercenariesAmount: 1).
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).
	self assert: ((aGame spaceshipMatchWith: id1) hasMercenaryWithId: id2 in: aGame).
]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseARedoCardReceivedByTheTitle [
	| aGame aBoard aTileCollection aMercenaryCard aRedoCard |
	

	aMercenaryCard := MercenaryCard new.
	aRedoCard := RedoCard new.

	aSpaceship := Spaceship with: (OrderedCollection with: aMercenaryCard) and: id1.
	
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
		
	aGame play: MercenaryCard by: id1 affecting: nil targeting: id2.
	aGame playTurn.
	
	self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 1.
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 1.

	aGame play: RedoCard by: id1 affecting: nil targeting: id3.
	
	self assert: (aGame spaceshipMatchWith: id1) getCards size equals: 0.
	self assert: (aGame spaceshipMatchWith: id1) getMercenaries size equals: 2.
	self assert: ((aGame spaceshipMatchWith: id1) getMercenaries anySatisfy: [ :each | each matchesId: id2 ]).


]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseASpeedCardReceivedByTheTile [

	| aGame aBoard aTileCollection aCard |
	aCard := SpeedCard new.

	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
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

	3 timesRepeat: [ aGame playTurn ].
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 3).

	aGame play: SpeedCard by: id1 affecting: nil targeting: id1.
	3 timesRepeat: [ aGame playTurn ].
	
	self assert: ((aGame spaceshipMatchWith: id1) isAt: position*2+1 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).



]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipCanUseAnAccelerationCardReceivedByTheTitle [
	|  aGame aBoard aTileCollection aCard  |
	
	aCard := AccelerationCard new.
	
	aTileBuilder with: (ObtainCardEffect with: aCard) at: position.
	aTileBuilder addWormholeFrom: 40 to: 49.
	aTileCollection := aTileBuilder build.
	
	aBoard := Board withSize: 60 andLapsToWin: 1 and: aTileCollection.
	
	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addSpaceship: aSpaceship3;
		addBoard: aBoard;
		addDice: (SequentialFixedDice onFaces: { position. 4. 10 });
		build.

	3 timesRepeat: [ aGame playTurn ].

	self assert: ((aGame spaceshipMatchWith: id1) isAt: position and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 4 and: 0).
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 10 and: 0).

	aGame play: AccelerationCard by: id1 affecting: nil targeting: nil.
	3 timesRepeat: [ aGame playTurn ].

	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 2).
	self assert: ((aGame spaceshipMatchWith: id1) isAt: (position * 2 + 1) and: 0).
	self assert: ((aGame spaceshipMatchWith: id2) isAt: 9 and: 0). 
	self assert: ((aGame spaceshipMatchWith: id3) isAt: 21 and: 0).


]

{ #category : 'tests' }
ObtainCardTest >> testIsValidIfSpaceshipReceivesCardWhenLandingOnCardTile [

	| aGame aBoard aTileCollection |
	
	aTileBuilder with: (ObtainCardEffect new) at: 4.
	aTileBuilder addWormholeFrom: 9 to: 15.
	aTileCollection := aTileBuilder build.

	aBoard := Board withSize: 20 andLapsToWin: 1 and: aTileCollection.

	aGame := aGameBuilder
		addSpaceship: aSpaceship;
		addSpaceship: aSpaceship2;
		addBoard: aBoard;
		addDice: (FixedDice onFace: 4);
		build.

	aGame playTurn. aGame playTurn.

	self assert: ((aGame spaceshipMatchWith: id1) isAt: 4 and: 0).
	self assert: ((aGame spaceshipMatchWith: id1) hasCardsAmount: 3).



]
