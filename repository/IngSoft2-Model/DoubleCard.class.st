Class {
	#name : 'DoubleCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
DoubleCard class >> canBePlayedBy: aSpaceship in: aGame [ 
]

{ #category : 'behavior' }
DoubleCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [
	aGame repeatTurn.
	aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
DoubleCard >> undoEffect: aGame [
]
