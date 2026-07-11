Class {
	#name : 'Dice',
	#superclass : 'Object',
	#instVars : [
		'maxRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Dice class >> numberOfSidesIsPositive: aNumberOfSides [

	aNumberOfSides <= 0 ifTrue: [
		Error signal: 'A dice should have a positive amount of sides' ]
]

{ #category : 'accessing' }
Dice class >> with: numberOfFaces [ 
	self numberOfSidesIsPositive: numberOfFaces.
	^ self new initializeAt: numberOfFaces.
]

{ #category : 'initialization' }
Dice >> initializeAt: aMaxRoll [

	maxRoll := aMaxRoll.
]

{ #category : 'initialization' }
Dice >> maxValue [
	^ maxRoll.
]

{ #category : 'roll' }
Dice >> roll [

	^ Random new nextIntegerBetween: 1 and: maxRoll.
	
]
