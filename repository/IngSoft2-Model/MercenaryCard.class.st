Class {
	#name : 'MercenaryCard',
	#superclass : 'PermanentCard',
	#instVars : [
		'affectedSpaceship',
		'ownerSpaceship'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
MercenaryCard >> = anotherCard [

^ (anotherCard compareID: id).
]

{ #category : 'comparing' }
MercenaryCard >> compareID: anId [ 
	^ id = anId.
]

{ #category : 'initialization' }
MercenaryCard >> initialize [
id := 'MercenaryCard-' , (0 to: 9999) atRandom asString.
]

{ #category : 'behavior' }
MercenaryCard >> playBy: aSpaceship in: aGame targeting: aTargetSpaceship [
	ownerSpaceship := aSpaceship.
   affectedSpaceship := aTargetSpaceship.

	aTargetSpaceship beMercenaryOf: aSpaceship.

	aGame addActivePermanentCard: self.
	aGame registerLastCardPlayed: self.
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
