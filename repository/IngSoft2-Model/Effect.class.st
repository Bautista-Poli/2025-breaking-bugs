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
Effect >> handleArriveOf: aSpaceship in: aGame [
    self applyTo: aSpaceship in: aGame.
]
