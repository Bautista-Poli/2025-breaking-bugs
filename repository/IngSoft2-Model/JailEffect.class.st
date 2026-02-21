Class {
	#name : 'JailEffect',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'operations' }
JailEffect >> applyTo: aSpaceship in: aGame [

	aSpaceship sendToJail.
   aGame registerAppliedEffect: self.
]
