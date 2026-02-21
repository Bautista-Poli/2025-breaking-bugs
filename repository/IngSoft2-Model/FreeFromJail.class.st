Class {
	#name : 'FreeFromJail',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
FreeFromJail >> handleRoll: aRoll for: aSpaceship in: aGame [ 
	(aGame board) move: aSpaceship by: aRoll.
   aGame board handleLandingOf: aSpaceship in: aGame.
]

{ #category : 'testing' }
FreeFromJail >> isInJail [
	^ false.
]
