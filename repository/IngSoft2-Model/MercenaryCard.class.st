Class {
	#name : 'MercenaryCard',
	#superclass : 'Card',
	#instVars : [
		'affectedSpaceship',
		'ownerSpaceship'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
MercenaryCard >> canBePlayedBy: aSpaceship in: aGame [
    (aGame isCurrentTurnOf: aSpaceship) ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
]

{ #category : 'initialization' }
MercenaryCard >> initialize [
id := 'MercenaryCard-' , (0 to: 9999) atRandom asString.
]

{ #category : 'behavior' }
MercenaryCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [
	ownerSpaceship := aSpaceship.
   affectedSpaceship := aTargetSpaceship.

	aTargetSpaceship beMercenaryOf: aSpaceship.

	aGame addActivePermanentCard: self.
	aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
MercenaryCard >> undoEffect: aGame [ 

	ownerSpaceship fire: affectedSpaceship.
]
