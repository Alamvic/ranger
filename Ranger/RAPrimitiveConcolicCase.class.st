Class {
	#name : #RAPrimitiveConcolicCase,
	#superclass : #RAVMConcolicCase,
	#instVars : [
		'selector'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAPrimitiveConcolicCase >> initializeVM: aVM [

	"Do nothing"
]

{ #category : #accessing }
RAPrimitiveConcolicCase >> selector [

	^ selector
]

{ #category : #accessing }
RAPrimitiveConcolicCase >> selector: anObject [

	selector := anObject
]
