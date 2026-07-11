Class {
	#name : 'MercenaryFleet',
	#superclass : 'Object',
	#instVars : [
		'mercenaries'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'adding' }
MercenaryFleet >> add: aSpaceship [ 
	mercenaries add: aSpaceship.
]

{ #category : 'as yet unclassified' }
MercenaryFleet >> bestRollFrom: aBaseRoll using: aDiceSet [

	| best |
	best := aBaseRoll.
	mercenaries size timesRepeat: [ best := aDiceSet roll max: best ].
	^ best
]

{ #category : 'behavior' }
MercenaryFleet >> fire: aSpaceship [ 
	mercenaries remove: aSpaceship ifAbsent: [].
]

{ #category : 'testing' }
MercenaryFleet >> hasAmount: aNumberOfMercenaries [ 
	^ mercenaries size = aNumberOfMercenaries.
]

{ #category : 'testing' }
MercenaryFleet >> hasHimAsMercenary: aSpaceship [ 
	^ mercenaries includes: aSpaceship
]

{ #category : 'testing' }
MercenaryFleet >> hasMercenaryWithId: anId [ 
	^ mercenaries anySatisfy: [ :each | each matchesId: anId ].
]

{ #category : 'initialization' }
MercenaryFleet >> initialize [ 
	mercenaries := OrderedCollection new.
]

{ #category : 'accessing' }
MercenaryFleet >> members [
	^ mercenaries deepCopy
]

{ #category : 'as yet unclassified' }
MercenaryFleet >> penalizeAll [
	mercenaries do: [ :mercenary | mercenary lowerAShield ]
]
