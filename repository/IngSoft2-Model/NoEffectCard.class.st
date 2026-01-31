Class {
	#name : 'NoEffectCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
NoEffectCard >> = anotherCard [

^ false.
]

{ #category : 'comparing' }
NoEffectCard >> compareID: anId [ 

^ false.
]

{ #category : 'behavior' }
NoEffectCard >> playBy: aSpaceship in: aGame targeting: aTarget [
    ^ self

]

{ #category : 'behavior' }
NoEffectCard >> undoEffect: aGame [

	
]
