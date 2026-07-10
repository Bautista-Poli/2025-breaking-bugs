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
HyperGravityEffect class >> withRoll: aRequiredRoll [ 
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
