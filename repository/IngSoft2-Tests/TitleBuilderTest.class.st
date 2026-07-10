Class {
	#name : 'TitleBuilderTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
TitleBuilderTest >> testIsValidIfTileEffectDistributionMatchesExpectedProbabilities [
	| finishLine aTileBuilder aTileCollection counter |
	finishLine := 15000. 
	aTileBuilder := TilesBuilder with: finishLine.
	aTileCollection := aTileBuilder buildRandom.
	
	counter := EffectDistributionCounter with: finishLine.
	aTileCollection do: [ :tile | tile countYourselfIn: counter ].

	self assert: (counter isNoEffectPercentageBetween: 39 and: 41).
	self assert: (counter isBlackHolePercentageBetween: 19 and: 21).
	self assert: (counter isHyperSpaceJumpPercentageBetween: 19 and: 21).
	self assert: (counter isMoonWalkPercentageBetween: 9 and: 11).
	self assert: (counter isHyperJumpPercentageBetween: 7 and: 9).
	self assert: (counter isAtomicBombPercentageBetween: 1 and: 3).

]

{ #category : 'tests' }
TitleBuilderTest >> testTileEffectDistributionMatchesExpectedProbabilitiesWithCardTitle [

	| finishLine aTileBuilder aTileCollection counter |
	finishLine := 15000. 
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder setRandomness: #(35 19 19 9 7 2 9).
	aTileCollection := aTileBuilder buildRandom.
	counter := EffectDistributionCounter with: finishLine.

	aTileCollection do: [ :tile | tile countYourselfIn: counter ].

	self assert: (counter isNoEffectPercentageBetween: 34 and: 36).
	self assert: (counter isBlackHolePercentageBetween: 18 and: 20).
	self assert: (counter isHyperSpaceJumpPercentageBetween: 18 and: 20).
	self assert: (counter isMoonWalkPercentageBetween: 8 and: 10).
	self assert: (counter isHyperJumpPercentageBetween: 6 and: 8).
	self assert: (counter isAtomicBombPercentageBetween: 1 and: 3).
	self assert: (counter isObtainCardPercentageBetween: 8 and: 10).

]

{ #category : 'tests' }
TitleBuilderTest >> testTileEffectDistributionMatchesExpectedProbabilitiesWithHyperGravity [

	| finishLine aTileBuilder aTileCollection counter |
	finishLine := 15000. 
	aTileBuilder := TilesBuilder with: finishLine.
	aTileBuilder setRandomnessWithHyperGravity: #(30 19 19 9 7 2 9 5).
	aTileCollection := aTileBuilder buildRandom.
	counter := EffectDistributionCounter with: finishLine.

	aTileCollection do: [ :tile | tile countYourselfIn: counter ].

	self assert: (counter isNoEffectPercentageBetween: 29 and: 31).
	self assert: (counter isBlackHolePercentageBetween: 18 and: 20).
	self assert: (counter isHyperSpaceJumpPercentageBetween: 18 and: 20).
	self assert: (counter isMoonWalkPercentageBetween: 8 and: 10).
	self assert: (counter isHyperJumpPercentageBetween: 6 and: 8).
	self assert: (counter isAtomicBombPercentageBetween: 1 and: 3).
	self assert: (counter isObtainCardPercentageBetween: 8 and: 10).
	self assert: (counter isHyperGravityPercentageBetween: 4 and: 6).

]
