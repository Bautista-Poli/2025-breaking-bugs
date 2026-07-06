Class {
	#name : 'RedoCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
RedoCard class >> canBePlayedBy: aSpaceship in: aGame [
	^ aGame lastCardThrown class canBePlayedBy: aSpaceship in: aGame.
]

{ #category : 'behavior' }
RedoCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    | cardToRedo |
    cardToRedo := aGame lastCardThrown.
    cardToRedo playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship.
]

{ #category : 'behavior' }
RedoCard >> undoEffect: aGame [

]
