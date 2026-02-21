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
	"Refactorizar cuando se haga nullSpaceship"
	| opponent |
	opponent := spaceships
		detect: [ :other | self isBattleOpponent: other for: aSpaceship ]
		ifNone: [ nil ].

	opponent ifNotNil: [ self resolveBattleBetween: aSpaceship and: opponent ].
]

{ #category : 'behavior' }
Battle >> getAllDiceValuesFrom: diceCollection [

	^ diceCollection
		  inject: 0
		  into: [ :sumOfValues :aDie | sumOfValues + aDie roll ]
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
	other getPosition = aSpaceship getPosition ifFalse: [ ^ false ].
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
