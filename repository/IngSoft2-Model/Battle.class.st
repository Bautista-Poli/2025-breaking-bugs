Class {
	#name : 'Battle',
	#superclass : 'Object',
	#instVars : [
		'dice'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'behavior' }
Battle >> checkIfNeededFor: aSpaceship against: spaceships using: dices [
    spaceships 
        detect: [ :other | aSpaceship canBattleAgainst: other ]
        ifFound: [ :opponent | self resolveBetween: aSpaceship and: opponent using: dices ]
        ifNone: [ ^ self. ]
]

{ #category : 'behavior' }
Battle >> determineLoserBetween: aSpaceship and: opponent using: dices [
    (aSpaceship rollBestValueUsing: dices) > (opponent rollBestValueUsing: dices)
        ifTrue: [ ^ opponent ].
    ^ aSpaceship
]

{ #category : 'behavior' }
Battle >> resolveBetween: aSpaceship and: opponent using: dices [
	 | loser |
	 loser := self determineLoserBetween: aSpaceship and: opponent using: dices.
    loser applyPenality.
    loser penalizeMercenaries.
]
