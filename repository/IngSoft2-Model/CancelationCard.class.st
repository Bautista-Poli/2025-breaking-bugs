Class {
	#name : 'CancelationCard',
	#superclass : 'InstantCard',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
CancelationCard >> = anotherCard [

^ (anotherCard compareID: id).

]

{ #category : 'comparing' }
CancelationCard >> compareID: anId [ 
	^ id = anId.
]

{ #category : 'initialization' }
CancelationCard >> initialize [
id := 'CancelationCard-' , (0 to: 9999) atRandom asString.
]

{ #category : 'behavior' }
CancelationCard >> playBy: aSpaceship in: aGame targeting: aCardToCancel [
    aCardToCancel undoEffect: aGame.
    aGame removeActivePermanentCard: aCardToCancel.
    aGame registerLastCardPlayed: self.
]
