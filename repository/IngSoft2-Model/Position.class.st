Class {
	#name : 'Position',
	#superclass : 'Object',
	#instVars : [
		'square',
		'laps'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
Position class >> at: aSquare lap: aLap [
    ^ self new initializeAt: aSquare lap: aLap.
]

{ #category : 'accessing' }
Position class >> start [
    ^ self at: 0 lap: 0
]

{ #category : 'accessing' }
Position >> initializeAt: aSquare lap: aLap [
    square := aSquare.
    laps := aLap.
]

{ #category : 'as yet unclassified' }
Position >> lap [
	^ laps.
]

{ #category : 'as yet unclassified' }
Position >> returnToStart [
	square := 0.
]

{ #category : 'accessing' }
Position >> square [
	^ square
]
