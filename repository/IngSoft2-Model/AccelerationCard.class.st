Class {
	#name : 'AccelerationCard',
	#superclass : 'PermanentCard',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'comparing' }
AccelerationCard >> = anotherCard [

^ (anotherCard compareID: id).
]

{ #category : 'behavior' }
AccelerationCard >> applyBonusTo: aRollValue for: aSpaceship [
    ^ aRollValue + 1.
]

{ #category : 'behavior' }
AccelerationCard >> canBePlayedBy: aSpaceship in: aGame [
		"NUEVO"
    ^ aGame isCurrentTurnOf: aSpaceship
]

{ #category : 'comparing' }
AccelerationCard >> compareID: anId [ 
	^ id = anId.
]

{ #category : 'initialization' }
AccelerationCard >> initialize [
id := 'AccelerationCard-' , (0 to: 9999) atRandom asString.
]

{ #category : 'behavior' }
AccelerationCard >> playBy: aSpaceship in: aGame targeting: aTarget [
    aGame addActivePermanentCard: self.
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
AccelerationCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [
    aGame addActivePermanentCard: self.
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
AccelerationCard >> undoEffect: aGame [
	^ self.
]
