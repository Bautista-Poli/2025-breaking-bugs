Class {
	#name : 'Battle',
	#superclass : 'Object',
	#instVars : [
		'spaceships',
		'dice'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Battle class >> with: spaceships and: dice [ 
	^ self new initializeWith: spaceships and: dice.
]

{ #category : 'behavior' }
Battle >> checkForBattleIfNeededWith: aSpaceship [
    | opponent |
    opponent := spaceships 
        detect: [ :other | aSpaceship canBattleAgainst: other ]
        ifNone: [ ^ self ]. "Salida temprana si no hay nadie"

    self resolveBattleBetween: aSpaceship and: opponent.
]

{ #category : 'initialization' }
Battle >> getAllValuesIncludingMercenariesOf: aSpaceship [

	^ aSpaceship rollBestValueUsing: dice
]

{ #category : 'initialization' }
Battle >> initializeWith: aCollectionOfSpacehips and: aCollectionOfDice [

	spaceships := aCollectionOfSpacehips.
	dice := aCollectionOfDice.
]

{ #category : 'behavior' }
Battle >> isBattleOpponent: other for: aSpaceship [
    other == aSpaceship ifTrue: [ ^ false ].
    (other isAtSamePositionAs: aSpaceship) ifFalse: [ ^ false ].
    (other hasHimAsMercenary: aSpaceship) ifTrue: [ ^ false ].
    ^ true

]

{ #category : 'behavior' }
Battle >> resolveBattleBetween: aSpaceship and: opponent [ 
	
	| loser spaceshipDiceValue oponentDiceValue |
	loser := aSpaceship.
	
	spaceshipDiceValue := self getAllValuesIncludingMercenariesOf: aSpaceship.
	oponentDiceValue := self getAllValuesIncludingMercenariesOf: opponent. 
	
	spaceshipDiceValue > oponentDiceValue ifTrue: [ loser :=  opponent].
	loser applyPenality. 
	loser getMercenaries do: [:mercenary | mercenary lowerAShield ].
]
