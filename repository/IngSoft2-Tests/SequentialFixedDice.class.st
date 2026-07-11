Class {
	#name : 'SequentialFixedDice',
	#superclass : 'Dice',
	#instVars : [
		'faceNumberCollection',
		'currentIndex'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'behavior' }
SequentialFixedDice class >> faceNumberArePositive: aFaceNumberCollection [
	aFaceNumberCollection do: [ :aFaceNumber | self faceNumberIsPositive: aFaceNumber ].

]

{ #category : 'behavior' }
SequentialFixedDice class >> faceNumberIsPositive: aFaceNumber [

	aFaceNumber <= 0 ifTrue: [
		Error signal: 'Only positive values are allowed for sequential fixed dice faces' ]

]

{ #category : 'creation' }
SequentialFixedDice class >> on: sides andFixedNumbers: fixedFaces [

	self faceNumberArePositive: fixedFaces.
	^ self new at: sides cyclingThrough: fixedFaces.
]

{ #category : 'creation' }
SequentialFixedDice class >> onFaces: aFaceNumberCollection [

	self faceNumberArePositive: aFaceNumberCollection.
	^ self basicNew at: (aFaceNumberCollection max) cyclingThrough: aFaceNumberCollection.
]

{ #category : 'initialization' }
SequentialFixedDice >> at: sides cyclingThrough: fixedFaces [

	maxRoll := sides.
	faceNumberCollection := fixedFaces.
	currentIndex := 0.
]

{ #category : 'behavior' }
SequentialFixedDice >> roll [
	currentIndex := currentIndex \\ faceNumberCollection size + 1.
	^ faceNumberCollection at: currentIndex.
]
