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
ShieldsEmpty >> canPlay [
	^ false.
]

{ #category : 'initialization' }
ShieldsEmpty >> handleEndOfCycleFor: aSpaceship [ 
    turnsRemaining := turnsRemaining - 1.
    
    turnsRemaining = 0 ifTrue: [
        aSpaceship changeShieldStatusTo: (ShieldsActive withCount: 3)
    ]

]

{ #category : 'initialization' }
ShieldsEmpty >> initialize [
    turnsRemaining := 3.
]

{ #category : 'initialization' }
ShieldsEmpty >> rechargeShieldsFor: aSpaceship [
    
    aSpaceship changeShieldStatusTo: (ShieldsActive withCount: 3).
]

{ #category : 'initialization' }
ShieldsEmpty >> shieldCount [ 
    ^ 0.
]
