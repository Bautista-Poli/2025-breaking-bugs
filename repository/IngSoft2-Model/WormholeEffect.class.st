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
    | delta |
    delta := targetPosition - aSpaceship position square.
    aGame move: aSpaceship by: delta.
    aGame checkForBattleInvolving: aSpaceship.
    aGame registerAppliedEffect: self.
]

{ #category : 'operations' }
WormholeEffect >> countYourself: aCounter [ 
]

{ #category : 'initialization' }
WormholeEffect >> initializeWith: exitPosition [
	targetPosition := exitPosition.
]

{ #category : 'as yet unclassified' }
WormholeEffect >> replacementFor: aFullBlockClosure [ 
	^ self 
]
