Class {
	#name : 'HyperSpaceJumpEffect',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'operations' }
HyperSpaceJumpEffect >> applyTo: aSpaceship in: aGame [

	| actualPosition |
	actualPosition := aSpaceship getPosition.
	(aGame board) move: aSpaceship by: 4.
	aSpaceship lowerAShield.
	aGame registerAppliedEffect: self
]

{ #category : 'operations' }
HyperSpaceJumpEffect >> countYourself: aCounter [
    aCounter countHyperSpaceJump.

]
