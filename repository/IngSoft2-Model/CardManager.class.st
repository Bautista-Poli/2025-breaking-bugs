Class {
	#name : 'CardManager',
	#superclass : 'Object',
	#instVars : [
		'activePermanentCards',
		'cardsThrown'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'adding' }
CardManager >> addActivePermanentCard: aCard [ 
	activePermanentCards add: aCard.
]

{ #category : 'as yet unclassified' }
CardManager >> applyBonusesTo: aBaseRoll for: aSpaceship [ 
	^ activePermanentCards
		  inject: aBaseRoll
		  into: [ :currentTotal :eachCard |
			  eachCard applyBonusTo: currentTotal for: aSpaceship ]
]

{ #category : 'behavior' }
CardManager >> getRealCard: aTargetCard [ 
	^ activePermanentCards
		  detect: [ :each | each class = aTargetCard ]
		  ifNone: [ Error signal: 'Cannot cancel a card that is not active' ]
]

{ #category : 'testing' }
CardManager >> hasActivePermanentCardOfType: aCardClass [ 
	^ activePermanentCards anySatisfy: [ :card | card isKindOf: aCardClass ]
]

{ #category : 'initialization' }
CardManager >> initialize [

	activePermanentCards := OrderedCollection new.
	cardsThrown := NoEffectCard new.
]

{ #category : 'accessing' }
CardManager >> lastCardThrown [
	^ cardsThrown
]

{ #category : 'accessing' }
CardManager >> registerLastCardPlayed: aCard [ 
	cardsThrown := aCard.
]

{ #category : 'removing' }
CardManager >> removeActivePermanentCard: aCard [ 
	activePermanentCards remove: aCard ifAbsent: [ ^ self ].
]
