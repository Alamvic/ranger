Class {
	#name : #RAConstraintSolution,
	#superclass : #Object,
	#instVars : [
		'solver',
		'path',
		'inputConstraints'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAConstraintSolution >> arguments [
	
	^ inputConstraints allButFirst
]

{ #category : #accessing }
RAConstraintSolution >> inputConstraints: aCollection [ 
	
	inputConstraints := aCollection
]

{ #category : #'as yet unclassified' }
RAConstraintSolution >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Path'> 
	
	^ path inspectionItems: aBuilder
]

{ #category : #testing }
RAConstraintSolution >> isEmpty [
	
	^ path isEmpty
]

{ #category : #testing }
RAConstraintSolution >> isFailure [
	
	^ path failure
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

{ #category : #testing }
RAConstraintSolution >> printOn: aStream [

	super printOn: aStream.
	
	path ifNil: [ ^ self ].
	
	aStream nextPut: $(.
	self parameterNames
		do: [ :e | aStream print: e]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $)
]

{ #category : #'value-accessing' }
RAConstraintSolution >> receiver [
	
	^ inputConstraints first
]

{ #category : #'value-accessing' }
RAConstraintSolution >> receiverTags [
	
	^ self receiver typeTag
]

{ #category : #accessing }
RAConstraintSolution >> solver [

	^ solver
]

{ #category : #accessing }
RAConstraintSolution >> solver: anObject [

	solver := anObject
]
