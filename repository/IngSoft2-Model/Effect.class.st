Class {
	#name : 'Effect',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'operations' }
Effect >> applyTo: aSpaceship in: aGame [

	self subclassResponsibility
]

{ #category : 'operations' }
Effect >> countYourself: aCounter [
    self subclassResponsibility
]

{ #category : 'operations' }
Effect >> isSameKindAs: anEffectOrClass [
	^ anEffectOrClass isClass
		ifTrue: [ self class = anEffectOrClass ]
		ifFalse: [ self class = anEffectOrClass class ]
]
