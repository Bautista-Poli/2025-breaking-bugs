Class {
	#name : 'RedoCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
RedoCard >> = anotherCard [

^ (anotherCard compareID: id).
]

{ #category : 'comparing' }
RedoCard >> compareID: anId [ 
	^ id = anId.
]

{ #category : 'initialization' }
RedoCard >> initialize [
	id := 'RedoCard-' , (0 to: 9999) atRandom asString.
]

{ #category : 'behavior' }
RedoCard >> playBy: aSpaceship in: aGame targeting: aTarget [
    | cardToRedo |
    cardToRedo := aGame lastCardThrown.
    cardToRedo playBy: aSpaceship in: aGame targeting: aTarget.
]

{ #category : 'behavior' }
RedoCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    | cardToRedo |
    cardToRedo := aGame lastCardThrown.
    cardToRedo playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship.
]
