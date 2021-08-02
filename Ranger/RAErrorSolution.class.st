Class {
	#name : #RAErrorSolution,
	#superclass : #Object,
	#instVars : [
		'selector',
		'vm',
		'error'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAErrorSolution >> error [

	^ error
]

{ #category : #accessing }
RAErrorSolution >> error: anObject [

	error := anObject
]

{ #category : #accessing }
RAErrorSolution >> selector [

	^ selector
]

{ #category : #accessing }
RAErrorSolution >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
RAErrorSolution >> vm [

	^ vm
]

{ #category : #accessing }
RAErrorSolution >> vm: anObject [

	vm := anObject
]
