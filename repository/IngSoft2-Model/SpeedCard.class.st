Class {
	#name : 'SpeedCard',
	#superclass : 'PermanentCard',
	#instVars : [
		'spaceshipAffected'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
SpeedCard >> = anotherCard [

^ (anotherCard compareID: id).
]

{ #category : 'behavior' }
SpeedCard >> applyBonusTo: aRollValue for: aSpaceship [
    ^ (aSpaceship = spaceshipAffected)
        ifTrue: [ aRollValue + 1 ]
        ifFalse: [ aRollValue ]
]

{ #category : 'behavior' }
SpeedCard >> checkIfEffectCanBeApplyToTarget: aTargetSpaceship [
]

{ #category : 'comparing' }
SpeedCard >> compareID: anId [ 
	^ id = anId.
]

{ #category : 'behavior' }
SpeedCard >> implementEfectBy: aSpaceship on: aTargetSpaceship in: aGame [ 
	
	spaceshipAffected := aSpaceship.
	aSpaceship moveAtHigherVelocity.
	aGame registerThrownCard: self.
]

{ #category : 'initialization' }
SpeedCard >> initialize [
id := 'Card-' , (0 to: 9999) atRandom asString.

]

{ #category : 'behavior' }
SpeedCard >> playBy: aSpaceship in: aGame targeting: aTargetSpaceship [
    "Guardamos a quién le damos el bono"
    spaceshipAffected := aTargetSpaceship.
    
    "Se registra como permanente para que el Game la consulte en cada tirada"
    aGame addActivePermanentCard: self.
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
SpeedCard >> undoEffect: aGame to: aTargetSpaceship [ 

	spaceshipAffected moveAtLowerVelocity
]
