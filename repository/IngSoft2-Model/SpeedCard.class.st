Class {
	#name : 'SpeedCard',
	#superclass : 'Card',
	#instVars : [
		'spaceshipAffected'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
SpeedCard >> applyBonusTo: aRollValue for: aSpaceship [
    ^ (aSpaceship = spaceshipAffected)
        ifTrue: [ aRollValue + 1 ]
        ifFalse: [ aRollValue ]
]

{ #category : 'behavior' }
SpeedCard >> canBePlayedBy: aSpaceship in: aGame [
    (aGame isCurrentTurnOf: aSpaceship) ifFalse: [ Error signal: 'Card cannot be played at this moment' ].
]

{ #category : 'initialization' }
SpeedCard >> initialize [
id := 'Card-' , (0 to: 9999) atRandom asString.

]

{ #category : 'behavior' }
SpeedCard >> playBy: aSpaceship in: aGame targeting: aTargetCard affecting: aTargetSpaceship [ 
    
    spaceshipAffected := aTargetSpaceship.
    
    aGame addActivePermanentCard: self.
    aGame registerLastCardPlayed: self.
]

{ #category : 'behavior' }
SpeedCard >> undoEffect: aGame [
]
