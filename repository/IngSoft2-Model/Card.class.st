Class {
	#name : 'Card',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
Card class >> canBePlayedBy: aSpaceship in: aGame [
]

{ #category : 'behavior' }
Card >> applyBonusTo: aRollValue for: aSpaceship [
    ^ aRollValue
]

{ #category : 'behavior' }
Card >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [
    self subclassResponsibility
]

{ #category : 'behavior' }
Card >> undoEffect: aGame [

	self subclassResponsibility
]
