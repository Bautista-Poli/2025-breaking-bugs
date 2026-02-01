Class {
	#name : 'RepeatCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
RepeatCard >> implementEffect: aPermanentCard by: aSpaceship to: aTargetSpaceship in: aGame [

	| lastEffectApplied |
	lastEffectApplied := aGame lastTileEffectApplied.
	lastEffectApplied applyTo: aTargetSpaceship in: aGame.
	aGame registerThrownCard: self.
]

{ #category : 'initialization' }
RepeatCard >> initialize [

	id := 'RepeatCard-' , (0 to: 9999) atRandom asString
]

{ #category : 'initialization' }
RepeatCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    | lastEffect |
    
    lastEffect := aGame lastTileEffectApplied.
    lastEffect applyTo: aTargetSpaceship in: aGame.
    
    aGame registerLastCardPlayed: self.
]
