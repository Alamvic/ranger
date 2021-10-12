Class {
	#name : #RAConstraintSolution,
	#superclass : #Object,
	#instVars : [
		'solver',
		'path',
		'inputConstraints',
		'outputConstraints'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAConstraintSolution >> exitCondition [
	
	^ path exitCondition
]

{ #category : #accessing }
RAConstraintSolution >> inputConstraints [
	^ inputConstraints
]

{ #category : #accessing }
RAConstraintSolution >> inputConstraints: aCollection [ 
	
	inputConstraints := aCollection
]

{ #category : #'as yet unclassified' }
RAConstraintSolution >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Path'> 
	
	path ifNil: [ ^ SpTablePresenter new ].
	^ path inspectionItems: aBuilder
]

{ #category : #testing }
RAConstraintSolution >> isEmpty [
	
	^ path isEmpty
]

{ #category : #testing }
RAConstraintSolution >> isFailure [
	
	^ path isFailure
]

{ #category : #testing }
RAConstraintSolution >> isInvalidIn: aTest [
	
	^ path exitCondition isInvalidIn: aTest
]

{ #category : #accessing }
RAConstraintSolution >> outputConstraints [

	^ outputConstraints
]

{ #category : #accessing }
RAConstraintSolution >> outputConstraints: anObject [

	outputConstraints := anObject
]

{ #category : #testing }
RAConstraintSolution >> parameterNames [
	
	^ path inputs
]

{ #category : #accessing }
RAConstraintSolution >> path [
	^ path
]

{ #category : #accessing }
RAConstraintSolution >> path: aRAPath [ 
	
	path := aRAPath
]

{ #category : #accessing }
RAConstraintSolution >> printOn: aStream [

	super printOn: aStream.
	path ifNil: [ ^ self ].
	aStream
		nextPutAll: '(';
		print: path exitCondition;
		nextPutAll: ')'
]

{ #category : #accessing }
RAConstraintSolution >> result [
	
	^ self exitCondition result
]

{ #category : #accessing }
RAConstraintSolution >> solver [

	^ solver
]

{ #category : #accessing }
RAConstraintSolution >> solver: anObject [

	solver := anObject
]
