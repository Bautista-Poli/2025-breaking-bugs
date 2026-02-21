Class {
	#name : 'ObtainCardEffect',
	#superclass : 'Effect',
	#instVars : [
		'cardSupplier'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
ObtainCardEffect class >> new [
	^ super new initializeWith: [ RandomCard obtainCard ].
]

{ #category : 'instance creation' }
ObtainCardEffect class >> with: aSpecificCard [ 
	^ self new initializeWith: [ aSpecificCard ].
]

{ #category : 'operations' }
ObtainCardEffect >> applyTo: aSpaceship in: aGame [
    aSpaceship addNewCard: (cardSupplier value).
	 aGame registerAppliedEffect: self
	
]

{ #category : 'initialization' }
ObtainCardEffect >> countYourself: aCounter [
    aCounter countObtainCard.
]

{ #category : 'initialization' }
ObtainCardEffect >> initializeWith: aCard [
	cardSupplier := aCard.
]
