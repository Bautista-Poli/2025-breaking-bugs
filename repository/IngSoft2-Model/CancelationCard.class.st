Class {
	#name : 'CancelationCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
CancelationCard >> playBy: aSpaceship in: aGame targeting: aCardToCancel affecting: aTargetSpaceship [
	| realCardToCancel |
	realCardToCancel := aGame getRealCard: aCardToCancel.
	realCardToCancel undoEffect: aGame.
	aGame removeActivePermanentCard: realCardToCancel.
	aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
CancelationCard >> undoEffect: aGame [

]
