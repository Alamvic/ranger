Class {
	#name : 'RAErrorSolution',
	#superclass : 'RAConstraintSolution',
	#instVars : [
		'selector',
		'vm',
		'error'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'validating' }
RAErrorSolution >> checkSupported [
	
	RAUnsupportedTestFailure signal: error messageText
]

{ #category : 'accessing' }
RAErrorSolution >> error [

	^ error
]

{ #category : 'accessing' }
RAErrorSolution >> error: anObject [

	error := anObject
]

{ #category : 'accessing' }
RAErrorSolution >> inputConstraints [

	^ inputConstraints
]

{ #category : 'accessing' }
RAErrorSolution >> inputConstraints: anObject [

	inputConstraints := anObject
]

{ #category : 'accessing' }
RAErrorSolution >> isErrorSolution [

	^ true
]

{ #category : 'accessing' }
RAErrorSolution >> path [

	^ path
]

{ #category : 'accessing' }
RAErrorSolution >> path: anObject [

	path := anObject
]

{ #category : 'accessing' }
RAErrorSolution >> selector [

	^ selector
]

{ #category : 'accessing' }
RAErrorSolution >> selector: anObject [

	selector := anObject
]

{ #category : 'printing' }
RAErrorSolution >> solutionLabel [

	^ 'Error'
]

{ #category : 'accessing' }
RAErrorSolution >> vm [

	^ vm
]

{ #category : 'accessing' }
RAErrorSolution >> vm: anObject [

	vm := anObject
]
