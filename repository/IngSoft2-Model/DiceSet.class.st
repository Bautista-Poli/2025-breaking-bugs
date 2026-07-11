Class {
	#name : 'DiceSet',
	#superclass : 'Object',
	#instVars : [
		'dice'
	],
	#classInstVars : [
		'dice'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
DiceSet class >> initializeWith: aCollectionOfDice [
	dice := aCollectionOfDice.
]

{ #category : 'initialization' }
DiceSet class >> maxPossibleRoll [
	^ dice inject: 0 into: [ :sum :aDie | sum + aDie maxValue ].
]

{ #category : 'initialization' }
DiceSet class >> roll [
	^ dice inject: 0 into: [ :sum :aDie | sum + aDie roll ].
]

{ #category : 'instance creation' }
DiceSet class >> validateNotEmpty: aCollectionOfDice [
	aCollectionOfDice isEmpty ifTrue: [
		Error signal: 'A DiceSet needs at least one dice' ]
]

{ #category : 'instance creation' }
DiceSet class >> with: aCollectionOfDice [
	self validateNotEmpty: aCollectionOfDice.
	^ self new initializeWith: aCollectionOfDice.
]

{ #category : 'initialization' }
DiceSet >> initializeWith: aCollectionOfDice [ 
	dice := aCollectionOfDice.
]

{ #category : 'accessing' }
DiceSet >> maxPossibleRoll [
	^ dice inject: 0 into: [ :sum :aDie | sum + aDie maxValue ].
]

{ #category : 'behavior' }
DiceSet >> roll [
	^ dice inject: 0 into: [ :sum :aDie | sum + aDie roll ].
]
