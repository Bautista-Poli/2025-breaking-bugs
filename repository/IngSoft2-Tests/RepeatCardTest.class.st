Class {
	#name : 'RepeatCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterABlackHoleEffectBeingAppliedThenItIsReapplied [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
    
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileBuilder with: BlackHoleEffect new at: 4.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andWormholeFrom: 80 to: 89 and: aTileCollection.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(4 5));
                 build.


    aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 0.

    aGame playTurn. 
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 5.

    aGame playCard: aRepeatCard by: aSpaceship targeting: aSpaceship.
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 1.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperJumpEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
    
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
    aSpaceship2 := Spaceship with: 'nave2'. 
	 aSpaceship3 := Spaceship with: 'nave3'.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (HyperJumpEffect withDescendingParsecsFrom: 30 step: 10)
                        at: 4.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andWormholeFrom: 80 to: 89 and: aTileCollection.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.


    aGame playTurn. aGame playTurn.  aGame playTurn. 
    
    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 19.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 14.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 9.

    aGame playCard: aRepeatCard by: aSpaceship1 targeting: aSpaceship2.

    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 19.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 29.
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 9.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAHyperSpaceJumpBeingAppliedThenItIsReapplied [

	| aSpaceship aSpaceship2 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
	aGameBuilder := GameBuilder new.
	aRepeatCard := RepeatCard new.
	aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'. 
	finishLine := 90.
	aTileBuilder := (TilesBuilder with: finishLine)
		                with: HyperSpaceJumpEffect new
		                at: 4.
	aTileCollection := aTileBuilder build.
	aBoard := Board
		          withSize: finishLine
		          andWormholeFrom: 80
		          to: 89
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship;
		         addSpaceship: aSpaceship2;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #(4 2));
		         build.

	aGame playTurn. aGame playTurn.

	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 8.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 2.

	aGame playCard: aRepeatCard by: aSpaceship targeting: aSpaceship.

	self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 12.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship) getShields equals: 1.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAMoonWalkEffectBeingAppliedThenItIsReapplied [
    | aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
    aSpaceship2 := Spaceship with: 'nave2'. 
	 aSpaceship3 := Spaceship with: 'nave3'.

    finishLine := 90.
    aTileBuilder := (TilesBuilder with: finishLine)
                        with: (MoonWalkEffect for: 3)
                        at: 9.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andWormholeFrom: 80 to: 85 and: aTileCollection.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addSpaceship: aSpaceship3;
                 addBoard: aBoard;
                 addDice: (SequentialFixedDice onFaces: #(7 8 9));
                 build.

    aGame playTurn. aGame playTurn.  aGame playTurn. 
    
    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 4. 
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 5. 
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 9.

    aGame playCard: aRepeatCard by: aSpaceship1 targeting: aSpaceship1.

    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 4. 
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 2. 
    self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 6.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterAnAtomicBombEffectBeingAppliedThenItIsReapplied [

	| aSpaceship1 aSpaceship2 aSpaceship3 aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
	aGameBuilder := GameBuilder new.
	aRepeatCard := RepeatCard new.
	aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
	aSpaceship2 := Spaceship with: 'nave2'. 
	aSpaceship3 := Spaceship with: 'nave3'.

	finishLine := 90.
	aTileBuilder := (TilesBuilder with: finishLine)
		                with: AtomicBombEffect new
		                at: 6.
	aTileCollection := aTileBuilder build.
	aBoard := Board
		          withSize: finishLine
		          andWormholeFrom: 80
		          to: 89
		          and: aTileCollection.

	aGame := aGameBuilder
		         addSpaceship: aSpaceship1;
		         addSpaceship: aSpaceship2;
		         addSpaceship: aSpaceship3;
		         addBoard: aBoard;
		         addDice: (SequentialFixedDice onFaces: #( 4 5 6 7 8 9 ));
		         build.

	aGame playTurn. aGame playTurn.  aGame playTurn. 
	self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.
	
	self assert: (aGame spaceshipMatching: aSpaceship1) getShields equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 2.
	self assert: (aGame spaceshipMatching: aSpaceship3) getShields equals: 2.

	aGame playTurn. aGame playTurn.  aGame playTurn. 

	self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 7.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 8.
	self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 9.

	aGame playCard: aRepeatCard by: aSpaceship1 targeting: aSpaceship2.

	self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 0.
	self assert: (aGame spaceshipMatching: aSpaceship3) getPosition equals: 0.

	self assert: (aGame spaceshipMatching: aSpaceship1) getShields equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship2) getShields equals: 1.
	self assert: (aGame spaceshipMatching: aSpaceship3) getShields equals: 1.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardAfterLandingOnANoEffectTileThenNothingHappens [
    | aSpaceship1 aSpaceship2 aGameBuilder aGame aBoard aRepeatCard |
    
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship1 := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
    aSpaceship2 := Spaceship with: 'nave2'. 

    aBoard := Board withSize: 90 andWormholeFrom: 80 to: 89.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship1;
                 addSpaceship: aSpaceship2;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 5);
                 build.


    aGame playTurn. aGame playTurn.
    
    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 5.
    aGame playCard: aRepeatCard by: aSpaceship1 targeting: aSpaceship2.

    self assert: (aGame spaceshipMatching: aSpaceship1) getPosition equals: 5.
    self assert: (aGame spaceshipMatching: aSpaceship2) getPosition equals: 0.
    self assert: (aGame spaceshipMatching: aSpaceship1) getCards isEmpty.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardBeforeAnyMoveThenNothingHappens [
    | aSpaceship aGameBuilder aGame aRepeatCard |
    
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: (Board withSize: 90 andWormholeFrom: 80 to: 89);
                 addDice: (FixedDice onFace: 5);
                 build.


    aGame playCard: aRepeatCard by: aSpaceship targeting: aSpaceship.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 0.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]

{ #category : 'tests' }
RepeatCardTest >> testWhenUsingARepeatCardHavingNotHavingAppliedAnEffectThenNothingHappens [
    | aSpaceship aGameBuilder finishLine aGame aBoard aTileCollection aTileBuilder aRepeatCard |
    
    aGameBuilder := GameBuilder new.
    aRepeatCard := RepeatCard new.
    aSpaceship := Spaceship with: (OrderedCollection with: aRepeatCard) and: 'nave1'.

    finishLine := 90.
    aTileBuilder := TilesBuilder with: finishLine.
    aTileCollection := aTileBuilder build.
    aBoard := Board withSize: finishLine andWormholeFrom: 80 to: 89 and: aTileCollection.
    
    aGame := aGameBuilder
                 addSpaceship: aSpaceship;
                 addBoard: aBoard;
                 addDice: (FixedDice onFace: 4);
                 build.

    aGame playTurn. 
    
    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 4.

    aGame playCard: aRepeatCard by: aSpaceship targeting: aSpaceship.

    self assert: (aGame spaceshipMatching: aSpaceship) getPosition equals: 4.
    self assert: (aGame spaceshipMatching: aSpaceship) getCards isEmpty.
]
