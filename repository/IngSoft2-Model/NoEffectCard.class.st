Class {
	#name : 'NoEffectCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
NoEffectCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    ^ self

]

{ #category : 'behavior' }
NoEffectCard >> undoEffect: aGame [

	
]
