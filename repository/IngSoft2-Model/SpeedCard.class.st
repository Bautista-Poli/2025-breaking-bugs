Class {
	#name : 'SpeedCard',
	#superclass : 'Card',
	#instVars : [
		'spaceshipAffected'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'testing' }
SpeedCard class >> canBePlayedBy: aSpaceship in: aGame [
    (aGame isCurrentTurnOf: aSpaceship) ifFalse: [ Error signal: 'Card cannot be played at this turn' ].
]

{ #category : 'behavior' }
SpeedCard >> applyBonusTo: aRollValue for: aSpaceship [
    ^ aSpaceship applyYourselfSpeedBonusTo: aRollValue ifYouAre: spaceshipAffected.
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
