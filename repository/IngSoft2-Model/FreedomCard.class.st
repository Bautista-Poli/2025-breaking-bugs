Class {
	#name : 'FreedomCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
FreedomCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [
    aTargetSpaceship releaseFromJail.
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
FreedomCard >> undoEffect: aGame [
]
