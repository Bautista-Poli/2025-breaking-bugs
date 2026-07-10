Class {
	#name : 'TilesBuilder',
	#superclass : 'Object',
	#instVars : [
		'size',
		'aTileCollection',
		'numberOfPositionsToGoBack',
		'noEffectPercentage',
		'blackholePercentage',
		'hyperSpaceJumpPercentage',
		'moonwalkPercentage',
		'hyperJumpPercentage',
		'atomicBombPercentage',
		'cardTitlePercentage',
		'wormholeCount',
		'hyperGravityRequiredRoll',
		'hyperGravityPercentage'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
TilesBuilder class >> with: finishLine [
	^ self new initializeWith: (Parsec with: finishLine).
]

{ #category : 'instance creation' }
TilesBuilder class >> withLighyears: finishLine [
	^ self new initializeWith: finishLine.
]

{ #category : 'behavior' }
TilesBuilder >> addWormholeFrom: entryPosition to: exitPosition [

	self validateAreNotNegative: entryPosition and: exitPosition.
	self validate: entryPosition notEqualTo: exitPosition.
	self validate: entryPosition and: exitPosition within: size.
	wormholeCount := wormholeCount + 2.
	self with: (WormholeEffect targeting: exitPosition) at: entryPosition.
	self with: (WormholeEffect targeting: entryPosition) at: exitPosition.

]

{ #category : 'behavior' }
TilesBuilder >> build [
	self validateWormholesPresence.
	^ aTileCollection
]

{ #category : 'behavior' }
TilesBuilder >> buildRandom [

	| weightedEffects |
	weightedEffects := Dictionary new
		                    at: [ NoEffect new ] put: noEffectPercentage;
		                    at: [ BlackHoleEffect new ] put: blackholePercentage;
		                    at: [ HyperSpaceJumpEffect new ] put: hyperSpaceJumpPercentage;
		                    at: [ MoonWalkEffect for: numberOfPositionsToGoBack ]
		                    put: moonwalkPercentage;
		                    at: [ HyperJumpEffect new ] put: hyperJumpPercentage;
		                    at: [ AtomicBombEffect new ] put: atomicBombPercentage;
		                    at: [ ObtainCardEffect new ] put: cardTitlePercentage;
		                    at: [ HyperGravityEffect withRoll: hyperGravityRequiredRoll ]
		                    put: hyperGravityPercentage;
		                    yourself.

	aTileCollection do: [ :aTile |
		aTile replaceIfEmptyWith: [
			(weightedEffects keys
				 atRandom: Random new
				 weighting: [ :block | weightedEffects at: block ]) value ] ].

	self validateWormholesPresence.
	^ aTileCollection
]

{ #category : 'initialize' }
TilesBuilder >> initializeWith: aSize [
	size := aSize.
	wormholeCount :=0.
	numberOfPositionsToGoBack := 4.
	aTileCollection := (1 to: size asParsec +1) collect: [ :i |
		                   Tile with: NoEffect new ].
	noEffectPercentage := 40.
	blackholePercentage := 20.
	hyperSpaceJumpPercentage := 20.
	moonwalkPercentage := 10.
	hyperJumpPercentage := 8.
	atomicBombPercentage := 2.
	cardTitlePercentage := 0.
	hyperGravityPercentage := 0.
	hyperGravityRequiredRoll := 2.
]

{ #category : 'behavior' }
TilesBuilder >> setForHyperGravity: aRequiredRoll [

	hyperGravityRequiredRoll := aRequiredRoll
]

{ #category : 'behavior' }
TilesBuilder >> setForMoonwalk: aNumberOfPositionsToGoBack [

	numberOfPositionsToGoBack := aNumberOfPositionsToGoBack
]

{ #category : 'behavior' }
TilesBuilder >> setRandomness: aCollectionOfPercentages [
	(aCollectionOfPercentages size = 7) ifFalse: [ Error signal: 'La colección debe tener 7 probabilidades' ].
	(aCollectionOfPercentages sum = 100) ifFalse: [ Error signal: 'Las probabilidades deben sumar 100' ].
	noEffectPercentage := aCollectionOfPercentages first.
	blackholePercentage := aCollectionOfPercentages at: 2.
	hyperSpaceJumpPercentage := aCollectionOfPercentages at: 3.
	moonwalkPercentage := aCollectionOfPercentages at: 4.
	hyperJumpPercentage := aCollectionOfPercentages at: 5.
	atomicBombPercentage := aCollectionOfPercentages at: 6.
	cardTitlePercentage := aCollectionOfPercentages at: 7.
]

{ #category : 'behavior' }
TilesBuilder >> setRandomnessWithHyperGravity: aCollectionOfPercentages [
	(aCollectionOfPercentages size = 8) ifFalse: [ Error signal: 'La colección debe tener 8 probabilidades' ].
	(aCollectionOfPercentages sum = 100) ifFalse: [ Error signal: 'Las probabilidades deben sumar 100' ].
	noEffectPercentage := aCollectionOfPercentages first.
	blackholePercentage := aCollectionOfPercentages at: 2.
	hyperSpaceJumpPercentage := aCollectionOfPercentages at: 3.
	moonwalkPercentage := aCollectionOfPercentages at: 4.
	hyperJumpPercentage := aCollectionOfPercentages at: 5.
	atomicBombPercentage := aCollectionOfPercentages at: 6.
	cardTitlePercentage := aCollectionOfPercentages at: 7.
	hyperGravityPercentage := aCollectionOfPercentages at: 8.
]

{ #category : 'behavior' }
TilesBuilder >> validate: wormholeEntry and: wormholeExit within: aBoardDistance [

	((aBoardDistance lessThan: wormholeEntry) or: [ aBoardDistance lessThan: wormholeExit ])
		ifTrue: [ Error signal: 'The wormhole cannot be outside of the board' ]

]

{ #category : 'behavior' }
TilesBuilder >> validate: wormholeEntry notEqualTo: wormholeExit [

	wormholeEntry = wormholeExit
		ifTrue: [ Error signal: 'The entry and the exit of the wormhole cannot be at the same position' ]

]

{ #category : 'behavior' }
TilesBuilder >> validateAreNotNegative: wormholeEntry and: wormholeExit [

	(wormholeEntry <= 0 or: [ wormholeExit <= 0 ])
		ifTrue: [ Error signal: 'The wormhole cannot have negative entry or exit' ]

]

{ #category : 'behavior' }
TilesBuilder >> validateWormholesPresence [
	(wormholeCount = 2) ifFalse: [ 
		Error signal: 'A game must have exactly two wormhole effects' 
	].
]

{ #category : 'behavior' }
TilesBuilder >> with: anEffect at: aPosition [

	aTileCollection at: (aPosition + 1) put: (Tile with: anEffect)
]
