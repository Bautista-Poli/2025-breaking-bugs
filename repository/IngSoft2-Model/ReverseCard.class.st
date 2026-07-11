Class {
	#name : 'ReverseCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
ReverseCard class >> canBePlayedBy: aSpaceship in: aGame [ 

]

{ #category : 'behavior' }
ReverseCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 

	aGame reverseTurnOrder.
	aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
ReverseCard >> undoEffect: aGame [
]
