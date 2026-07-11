Class {
	#name : 'InHyperGravity',
	#superclass : 'Object',
	#instVars : [
		'requiredRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
InHyperGravity class >> withRequiered: aRollValue [ 
	^ self new initializeWith: aRollValue.
]

{ #category : 'as yet unclassified' }
InHyperGravity >> handleRoll: aRollValue for: aSpaceship in: aGame [ 
	aRollValue >= requiredRoll ifFalse: [^self].
	aSpaceship releaseFromJail.
]

{ #category : 'initialization' }
InHyperGravity >> initializeWith: aRequiredRoll [ 
	requiredRoll := aRequiredRoll
]
