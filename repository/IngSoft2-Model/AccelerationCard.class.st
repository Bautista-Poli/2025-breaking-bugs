Class {
	#name : 'AccelerationCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
AccelerationCard class >> canBePlayedBy: aSpaceship in: aGame [
    (aGame isCurrentTurnOf: aSpaceship) ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
]

{ #category : 'behavior' }
AccelerationCard >> applyBonusTo: aRollValue for: aSpaceship [
    ^ aRollValue + 1.
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
