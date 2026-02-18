Class {
	#name : 'WormholeEffect',
	#superclass : 'Effect',
	#instVars : [
		'targetPosition'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
WormholeEffect class >> targeting: exitPosition [
	^ self new initializeWith: exitPosition.

]

{ #category : 'operations' }
WormholeEffect >> applyTo: aSpaceship in: aGame [ 

    aSpaceship moveToPosition: targetPosition.
	 aGame checkForBattleInvolving: aSpaceship.
    aGame registerAppliedEffect: self.
]

{ #category : 'initialization' }
WormholeEffect >> initializeWith: exitPosition [
	targetPosition := exitPosition.
]
