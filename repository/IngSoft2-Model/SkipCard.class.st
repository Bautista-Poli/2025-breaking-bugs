Class {
	#name : 'SkipCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
SkipCard class >> canBePlayedBy: aSpaceship in: aGame [ 
]

{ #category : 'behavior' }
SkipCard >> playBy: aSpaceship in: aGame targeting: anUndefinedObject affecting: aSpaceship4 [ 
	aGame skipCurrentTurn.
	aGame registerLastCardPlayed: self.
]
