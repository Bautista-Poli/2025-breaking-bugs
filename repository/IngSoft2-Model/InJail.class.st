Class {
	#name : 'InJail',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
InJail >> handleRoll: aRoll for: aSpaceship in: aGame [ 
	(aGame isMaxRoll: aRoll) ifFalse: [ ^self ].
	aSpaceship releaseFromJail.
   (aGame board) move: aSpaceship by: aRoll.
   aGame board handleLandingOf: aSpaceship in: aGame.
]

{ #category : 'testing' }
InJail >> isInJail [
	^ true
]
