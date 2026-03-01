Class {
	#name : 'FreeFromJail',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
FreeFromJail >> handleHyperGravityRoll: anInteger for: aSpaceship in: aGame [ 
]

{ #category : 'as yet unclassified' }
FreeFromJail >> handleRoll: aRoll for: aSpaceship in: aGame [ 
	aGame move: aSpaceship by: aRoll.
   aGame handleLandingOf: aSpaceship.
]

{ #category : 'testing' }
FreeFromJail >> isInJail [
	^ false.
]
