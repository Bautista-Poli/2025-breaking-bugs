Class {
	#name : 'HyperSpaceJumpEffect',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'operations' }
HyperSpaceJumpEffect >> applyTo: aSpaceship in: aGame [
   	 aGame move: aSpaceship by: 4.
    aSpaceship lowerAShield.
    aGame registerAppliedEffect: self.
    aGame checkForBattleInvolving: aSpaceship.
]

{ #category : 'operations' }
HyperSpaceJumpEffect >> countYourself: aCounter [
    aCounter countHyperSpaceJump.

]
