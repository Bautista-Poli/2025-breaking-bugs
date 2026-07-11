Class {
	#name : 'ShieldsEmpty',
	#superclass : 'Object',
	#instVars : [
		'turnsRemaining'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
ShieldsEmpty >> handleEndOfCycleFor: aSpaceship [ 
    
    turnsRemaining = 0 ifTrue: [
        aSpaceship changeShieldStatusTo: (ShieldsActive withCount: 3)
    ].
	 turnsRemaining := turnsRemaining - 1.

]

{ #category : 'testing' }
ShieldsEmpty >> hasAmount: aNumberOfShields [ 
	^ aNumberOfShields=0.
]

{ #category : 'initialization' }
ShieldsEmpty >> initialize [
    turnsRemaining := 2.
]

{ #category : 'as yet unclassified' }
ShieldsEmpty >> playIfPosible: aSpaceship in: aGame [ 

]

{ #category : 'initialization' }
ShieldsEmpty >> rechargeShieldsFor: aSpaceship [
    
    aSpaceship changeShieldStatusTo: (ShieldsActive withCount: 3).
]

{ #category : 'initialization' }
ShieldsEmpty >> shieldCount [ 
    ^ 0.
]
