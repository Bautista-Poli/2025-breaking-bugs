Class {
	#name : 'HyperJumpEffect',
	#superclass : 'Effect',
	#instVars : [
		'currentIndex',
		'distanceToAdvance'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
HyperJumpEffect class >> withDescendingLightYearsFrom: maxLightYears step: stepSize [
	| distances current |
	current := maxLightYears.
	distances := OrderedCollection new.

	[ current > 0 ] whileTrue: [
		distances add: (LightYear with: current).
		current := current - stepSize ].

	^ self new initializeWith: distances asArray
]

{ #category : 'as yet unclassified' }
HyperJumpEffect class >> withDescendingParsecsFrom: maxParsecs step: stepSize [
	| distances current |
	current := maxParsecs.
	distances := OrderedCollection new.

	[ current > 0 ] whileTrue: [
		distances add: (Parsec with: current).
		current := current - stepSize ].

	^ self new initializeWith: distances asArray.
]

{ #category : 'operations' }
HyperJumpEffect >> applyTo: aSpaceship in: aGame [

	| nextDistance tilesToAdvance |

	nextDistance := self nextDistanceToAdvance.
	tilesToAdvance := aGame tilesToMoveForDistance: nextDistance.

	aGame move: aSpaceship by: tilesToAdvance.
	aGame checkForBattleInvolving: aSpaceship.
	aGame registerAppliedEffect: self.
]

{ #category : 'initialization' }
HyperJumpEffect >> countYourself: aCounter [
    aCounter countHyperJump.

]

{ #category : 'initialization' }
HyperJumpEffect >> initializeWith: aDistanceArray [

	distanceToAdvance := aDistanceArray.
	currentIndex := 0
]

{ #category : 'initialization' }
HyperJumpEffect >> nextDistanceToAdvance [
	currentIndex := (currentIndex \\ distanceToAdvance size) + 1.
	^ distanceToAdvance at: currentIndex
]
