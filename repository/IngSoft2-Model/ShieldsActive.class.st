Class {
	#name : 'ShieldsActive',
	#superclass : 'Object',
	#instVars : [
		'countOfShields'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
ShieldsActive class >> withCount: aNumberOfShields [
    ^ self new initializeWithCount: aNumberOfShields.
]

{ #category : 'initialization' }
ShieldsActive >> canPlay [ 
    ^ true
]

{ #category : 'initialization' }
ShieldsActive >> handleEndOfCycleFor: aSpaceship [
]

{ #category : 'testing' }
ShieldsActive >> hasAmount: aNumberOfShields [ 
	^ countOfShields = aNumberOfShields
]

{ #category : 'initialization' }
ShieldsActive >> initializeWithCount: aNumberOfShields [
    countOfShields := aNumberOfShields.
]

{ #category : 'initialization' }
ShieldsActive >> lowerShieldFor: aSpaceship [ 
    countOfShields := countOfShields - 1.
    countOfShields = 0 ifTrue: [ 
        aSpaceship changeShieldStatusTo: ShieldsEmpty new]
    
]

{ #category : 'as yet unclassified' }
ShieldsActive >> playIfPosible: aSpaceship in: aGame [ 
	 | roll |
    roll := aGame rollFor: aSpaceship.
    aSpaceship handleRollFromShields: roll in: aGame.
]

{ #category : 'initialization' }
ShieldsActive >> rechargeShieldsFor: aSpaceship [ 
    countOfShields := 3.
    
]

{ #category : 'initialization' }
ShieldsActive >> shieldCount [ 
    ^ countOfShields.
]
