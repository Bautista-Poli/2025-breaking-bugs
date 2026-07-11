Class {
	#name : 'HyperGravityEffect',
	#superclass : 'Effect',
	#instVars : [
		'requiredRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
HyperGravityEffect class >> withIn: aMaxRoll [
	^ self new initializeWith: (1 to: aMaxRoll) atRandom.
]

{ #category : 'as yet unclassified' }
HyperGravityEffect class >> withRoll: aRequiredRoll in: aMaxRoll [ 
	(aRequiredRoll > aMaxRoll) ifTrue: [
		Error signal: 'HyperGravity required roll cannot be greater than the maximum possible dice roll' ].
	^ self new initializeWith: aRequiredRoll
]

{ #category : 'initialization' }
HyperGravityEffect >> applyTo: aSpaceship in: aGame [
	aSpaceship sendToHyperGravityRequiring: requiredRoll.
	aGame registerAppliedEffect: self.
]

{ #category : 'operations' }
HyperGravityEffect >> countYourself: aCounter [ 
	aCounter countHyperGravity.
]

{ #category : 'initialization' }
HyperGravityEffect >> initializeWith: aRequiredRoll [ 
	requiredRoll := aRequiredRoll
]
