Class {
	#name : 'MoonWalkEffect',
	#superclass : 'Effect',
	#instVars : [
		'numberOfPositionsToGoBack'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
MoonWalkEffect class >> for: aNumberOfPositionToGoBack [

	^ self new initializeFor: aNumberOfPositionToGoBack
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship in: aGame [
	aGame spaceshipsExcept: aSpaceship do: [ :ship |
		(aGame board) move: ship by: (numberOfPositionsToGoBack negated)
	].

	aGame registerAppliedEffect: self.
]

{ #category : 'operations' }
MoonWalkEffect >> countYourself: aCounter [
    aCounter countMoonWalk.
]

{ #category : 'initialization' }
MoonWalkEffect >> initializeFor: aNumberOfPositionsToGoBack [

	numberOfPositionsToGoBack := aNumberOfPositionsToGoBack
]
