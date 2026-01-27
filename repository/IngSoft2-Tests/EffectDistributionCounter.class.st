Class {
	#name : 'EffectDistributionCounter',
	#superclass : 'Object',
	#instVars : [
		'atomicBombCount',
		'moonWalkCount',
		'noEffectCount',
		'hyperJumpCount',
		'blackHoleCount',
		'hyperSpaceJumpCount',
		'obtainCardCount',
		'total'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'instance creation' }
EffectDistributionCounter class >> with: totalNumberOfTitles [
	^ self new initializeWith: totalNumberOfTitles.
]

{ #category : 'initialization' }
EffectDistributionCounter >> countAtomicBomb [
	atomicBombCount := atomicBombCount + 1.
]

{ #category : 'initialization' }
EffectDistributionCounter >> countBlackHole [
blackHoleCount := blackHoleCount + 1.
]

{ #category : 'initialization' }
EffectDistributionCounter >> countHyperJump [
hyperJumpCount := hyperJumpCount + 1.

]

{ #category : 'initialization' }
EffectDistributionCounter >> countHyperSpaceJump [
hyperSpaceJumpCount := hyperSpaceJumpCount + 1.

]

{ #category : 'initialization' }
EffectDistributionCounter >> countMoonWalk [
	moonWalkCount := moonWalkCount + 1.
]

{ #category : 'initialization' }
EffectDistributionCounter >> countNoEffect [
	noEffectCount := noEffectCount + 1.
]

{ #category : 'initialization' }
EffectDistributionCounter >> countObtainCard [
	obtainCardCount := obtainCardCount + 1.
]

{ #category : 'initialization' }
EffectDistributionCounter >> initializeWith: totalNumberOfTitles [
	atomicBombCount := 0.
	moonWalkCount := 0.
	noEffectCount := 0.
	hyperJumpCount := 0.
	blackHoleCount := 0.
	hyperSpaceJumpCount := 0.
	obtainCardCount := 0.
	total := totalNumberOfTitles.
]

{ #category : 'initialization' }
EffectDistributionCounter >> isAtomicBombPercentageBetween: aFloor and: aCeiling [ 
	^ ((atomicBombCount / total) * 100) between: aFloor and: aCeiling.
]

{ #category : 'testing' }
EffectDistributionCounter >> isBlackHolePercentageBetween: aFloor and: aCeiling [ 
	^ ((blackHoleCount / total) * 100) between: aFloor and: aCeiling.
]

{ #category : 'testing' }
EffectDistributionCounter >> isHyperJumpPercentageBetween: aFloor and: aCeiling [ 
	^ (hyperJumpCount / total) * 100 between: aFloor and: aCeiling.
]

{ #category : 'testing' }
EffectDistributionCounter >> isHyperSpaceJumpPercentageBetween: aFloor and: aCeiling [ 
	^ ((hyperSpaceJumpCount / total) * 100) between: aFloor and: aCeiling.
]

{ #category : 'testing' }
EffectDistributionCounter >> isMoonWalkPercentageBetween: aFloor and: aCeiling [ 
	^ (moonWalkCount / total) * 100 between: aFloor and: aCeiling.
]

{ #category : 'initialization' }
EffectDistributionCounter >> isNoEffectPercentageBetween: aFloor and: aCeiling [ 
	^ ((noEffectCount / total) * 100) between: aFloor and: aCeiling.
]

{ #category : 'testing' }
EffectDistributionCounter >> isObtainCardPercentageBetween: aFloor and: aCeiling [ 
	^ (obtainCardCount / total) * 100 between: aFloor and: aCeiling.
]
