Class {
	#name : 'SpaceshipTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpaceshipTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
SpaceshipTest >> testWhenCreatingASpaceshipThenItIsAtTheInitialPosition [

	| aSpaceship |
	aSpaceship := Spaceship with: 'nave1'.

	self assert: (aSpaceship isAtPosition: 0)
]

{ #category : 'tests' }
SpaceshipTest >> testWhenMoving3PositionsThen3IsTheFinalPosition [

	| aSpaceship finalPosition |
	aSpaceship := Spaceship with: 'nave1'.
	finalPosition := 3.

	aSpaceship moveToPosition: finalPosition.

	self assert: (aSpaceship isAtPosition: finalPosition)
]

{ #category : 'tests' }
SpaceshipTest >> testWhenTryingToMoveToANegativePositionTheSpaceshipIsNotAllowed [

	| aSpaceship finalPosition |
	aSpaceship := Spaceship with: 'nave1'.
	finalPosition := -1.

	self
		should: [ aSpaceship moveToPosition: finalPosition ]
		raise: Error
		withMessageText: 'The spaceship cannot move to a negative position'
]
