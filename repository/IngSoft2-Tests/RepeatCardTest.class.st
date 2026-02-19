Class {
	#name : 'RepeatCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterABlackHoleEffectBeingAppliedThenItIsReapplied [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder with: BlackHoleEffect new at: 4.
	 aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(4 5));
                 build.

    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.

    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 5.

    aGame playCard: aRepeatCard by: id targeting: id.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperJumpEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4.
	 aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine*2 andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.

    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 14.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.

    aGame playCard: aRepeatCard by: id1 targeting: id2.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 19.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 29.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperSpaceJumpBeingAppliedThenItIsReapplied [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 |
	aGameBuilder := GameBuilder new.
	aRepeatCard := RepeatCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.

	aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
	aSpaceship2 := Spaceship with: id2.

	finishLine := 90.
	aTileBuilder := (TilesBuilder with: finishLine)
		                with: HyperSpaceJumpEffect new
		                at: 4.
	aTileBuilder addWormholeFrom: 80 to: 89.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: finishLine
					 andLapsToWin: 1
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(4 2));
		         build.

	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 2.
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.

	aGame playCard: aRepeatCard by: id1 targeting: id1.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 12.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 2.
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 1.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAMoonWalkEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.
    id3 := 'nave3'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.
    aSpaceship3 := Spaceship with: id3.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (MoonWalkEffect for: 3)
                        at: 9.
	 aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(7 8 9));
                 build.

    aGame playTurn. aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 4.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 5.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.

    aGame playCard: aRepeatCard by: id1 targeting: id1.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 4.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 2.
    self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 6.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAnAtomicBombEffectBeingAppliedThenItIsReapplied [

	| aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id1 id2 id3 |
	aGameBuilder := GameBuilder new.
	aRepeatCard := RepeatCard new.

	id1 := 'nave1'.
	id2 := 'nave2'.
	id3 := 'nave3'.

	aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
	aSpaceship2 := Spaceship with: id2.
	aSpaceship3 := Spaceship with: id3.

	finishLine := 90.
	aTileBuilder := (TilesBuilder with: finishLine)
		                with: AtomicBombEffect new
		                at: 6.
	aTileBuilder addWormholeFrom: 80 to: 89.
	aTileCollection := aTileBuilder build.

	aBoard := Board
		          withSize: finishLine
					 andLapsToWin: 1
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(4 5 6 7 8 9));
		         build.

	aGame playTurn. aGame playTurn. aGame playTurn.
	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.
	
	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 2.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 2.

	aGame playTurn. aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 7.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 8.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 9.

	aGame playCard: aRepeatCard by: id1 targeting: id2.

	self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 0.
	self assert: (aGame spaceshipMatchWith: id3) getPosition equals: 0.

	self assert: (aGame spaceshipMatchWith: id1) getShields equals: 1.
	self assert: (aGame spaceshipMatchWith: id2) getShields equals: 1.
	self assert: (aGame spaceshipMatchWith: id3) getShields equals: 1.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterLandingOnANoEffectTileThenNothingHappens [
    | aSpaceship1 aSpaceship2 aGameBuilder aGame aBoard aRepeatCard id1 id2 |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.

    id1 := 'nave1'.
    id2 := 'nave2'.

    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: id1.
    aSpaceship2 := Spaceship with: id2.

    aBoard := Board withSize: 90 andWormholeFrom: 80 to: 89.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 5);
                 build.

    aGame playTurn. aGame playTurn.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 5.
    aGame playCard: aRepeatCard by: id1 targeting: id2.

    self assert: (aGame spaceshipMatchWith: id1) getPosition equals: 5.
    self assert: (aGame spaceshipMatchWith: id2) getPosition equals: 0.
    self assert: (aGame spaceshipMatchWith: id1) getCards isEmpty.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardBeforeAnyMoveThenNothingHappens [
    | aSpaceship aGameBuilder aGame aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: 5);
                 build.

    aGame playCard: aRepeatCard by: id targeting: id.

    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 0.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardHavingNotHavingAppliedAnEffectThenNothingHappens [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard id |

    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.

    id := 'nave1'.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: id.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
	 aTileBuilder addWormholeFrom: 80 to: 89.
    aTileCollection := aTileBuilder build.

    aBoard := Board withSize: finishLine andLapsToWin: 1 and: aTileCollection.

    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.

    aGame playTurn.
    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 4.

    aGame playCard: aRepeatCard by: id targeting: id.

    self assert: (aGame spaceshipMatchWith: id) getPosition equals: 4.
    self assert: (aGame spaceshipMatchWith: id) getCards isEmpty.

]
