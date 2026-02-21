Class {
	#name : 'FixedDice',
	#superclass : 'Dice',
	#instVars : [
		'fixedFace'
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
	^ self new initializeOn: faces andFixedNumber: aFixedNumber
]

{ #category : 'as yet unclassified' }
FixedDice class >> onFace: aFaceNumber [

	self faceNumberIsPositive: aFaceNumber.
	^ self new initializeOn: aFaceNumber andFixedNumber: aFaceNumber.
]

{ #category : 'initialization' }
FixedDice >> initializeOn: faces andFixedNumber: aFixedFace [

	fixedFace := aFixedFace.
	aNumberOfSides := faces.
]

{ #category : 'behavior' }
FixedDice >> roll [

	^ fixedFace
]
