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

{ #category : 'behavior' }
RedoCard >> checkIfEffectCanBeApplyToTarget: aTargetSpaceship [
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
RedoCard >> isInstant [
	^ true.
]

{ #category : 'behavior' }
RedoCard >> isPermanent [

	^ false.
]

{ #category : 'behavior' }
RedoCard >> playBy: aSpaceship in: aGame targeting: aTarget [
    | cardToRedo |
    cardToRedo := aGame lastCardThrown.
    cardToRedo playBy: aSpaceship in: aGame targeting: aTarget.
]
