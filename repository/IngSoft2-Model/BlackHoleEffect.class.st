Class {
	#name : 'BlackHoleEffect',
	#superclass : 'Effect',
	#instVars : [
		'numberOfPositionsToGoBack'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'operations' }
BlackHoleEffect >> applyTo: aSpaceship in: aGame [
    (aGame board) move: aSpaceship by: numberOfPositionsToGoBack negated.
    aGame registerAppliedEffect: self.
    aGame checkForBattleInvolving: aSpaceship.
]

{ #category : 'operations' }
BlackHoleEffect >> countYourself: aCounter [
    aCounter countBlackHole.
]

{ #category : 'initialization' }
BlackHoleEffect >> initialize [ 
	numberOfPositionsToGoBack := 4.
]
