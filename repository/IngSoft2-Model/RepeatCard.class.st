Class {
	#name : 'RepeatCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
RepeatCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    | lastEffect |
    
    lastEffect := aGame lastTileEffectApplied.
    lastEffect applyTo: aTargetSpaceship in: aGame.
    
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
RepeatCard >> undoEffect: aGame [

]
