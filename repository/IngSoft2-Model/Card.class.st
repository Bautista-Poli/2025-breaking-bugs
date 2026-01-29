Class {
	#name : 'Card',
	#superclass : 'Object',
	#instVars : [
		'id'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
Card >> canBePlayedBy: aSpaceship in: aGame [
    ^ true
]

{ #category : 'comparing' }
Card >> compareID: anId [ 

	self subclassResponsibility
]

{ #category : 'behavior' }
Card >> isInstant [

	self subclassResponsibility
]

{ #category : 'behavior' }
Card >> isPermanent [

	self subclassResponsibility
]

{ #category : 'behavior' }
Card >> playBy: aSpaceship in: aGame targeting: aTarget [
    self subclassResponsibility
]
