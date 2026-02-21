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
	^ self new initializeOn: sides andFixedNumber: fixedFaces.
]

{ #category : 'creation' }
SequentialFixedDice class >> onFaces: aFaceNumberCollection [

	self faceNumberArePositive: aFaceNumberCollection.
	^ self new initializeOn: 100 andFixedNumber: aFaceNumberCollection.
]

{ #category : 'initialization' }
SequentialFixedDice >> initializeOn: sides andFixedNumber: fixedFaces [

	aNumberOfSides := sides.
	faceNumberCollection := fixedFaces.
	currentIndex := 0.
]

{ #category : 'initialization' }
SequentialFixedDice >> initializeOnFace: aFaceNumberCollection [

	faceNumberCollection := aFaceNumberCollection.
	currentIndex := 0.
]

{ #category : 'behavior' }
SequentialFixedDice >> roll [
	currentIndex := currentIndex \\ faceNumberCollection size + 1.
	^ faceNumberCollection at: currentIndex.
]
