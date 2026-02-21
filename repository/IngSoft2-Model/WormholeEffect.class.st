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

    (aGame board) move: aSpaceship by: (targetPosition - aSpaceship getPosition).
	 aGame checkForBattleInvolving: aSpaceship.
]

{ #category : 'initialization' }
WormholeEffect >> initializeWith: exitPosition [
	targetPosition := exitPosition.
]
