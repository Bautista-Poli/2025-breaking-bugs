Class {
	#name : 'FixedDice',
	#superclass : 'Dice',
	#instVars : [
		'fixedFace',
		'maxRoll'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
FixedDice class >> faceNumberIsPositive: aFaceNumber [

	aFaceNumber <= 0 ifTrue: [
		Error signal: 'A fixed dice should be fixed on a positive face' ]
]

{ #category : 'as yet unclassified' }
FixedDice class >> on: faces andFixedNumber: aFixedNumber [

	self faceNumberIsPositive: aFixedNumber.
	self faceNumberIsPositive: faces.
	^ self new initializeWithMaxRoll: faces fixedAt: aFixedNumber.
]

{ #category : 'as yet unclassified' }
FixedDice class >> onFace: aFaceNumber [

	^ self withSides: aFaceNumber fixedAt: aFaceNumber.
]

{ #category : 'as yet unclassified' }
FixedDice class >> withSides: aMaxRoll fixedAt: aFace [

	self faceNumberIsPositive: aFace.
	self faceNumberIsPositive: aMaxRoll.
	^ self basicNew initializeWithMaxRoll: aMaxRoll fixedAt: aFace.
]

{ #category : 'initialization' }
FixedDice >> initializeWithMaxRoll: aMaxRoll fixedAt: aFixedFace [

	fixedFace := aFixedFace.
	maxRoll := aMaxRoll.
]

{ #category : 'behavior' }
FixedDice >> roll [

	^ fixedFace
]
