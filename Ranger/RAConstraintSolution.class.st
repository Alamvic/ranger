Class {
	#name : #RAConstraintSolution,
	#superclass : #Object,
	#instVars : [
		'solver',
		'variables',
		'path',
		'numberOfArguments',
		'objectBuilder'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'value-accessing' }
RAConstraintSolution >> argument: index [
	
	^ self stackValue: numberOfArguments - index
]

{ #category : #accessing }
RAConstraintSolution >> arguments [
	
	^ (numberOfArguments - 1 to: 0 by: -1) collect: [ :i | self stackValue: i ]
]

{ #category : #'as yet unclassified' }
RAConstraintSolution >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Path'> 
	
	^ path inspectionItems: aBuilder
]

{ #category : #'value-setup' }
RAConstraintSolution >> instantiate: aRAObject [ 
	
	aRAObject typeTag = 0 ifTrue: [ 
		^ objectBuilder
			allocateNewSpaceSlots: 0 "It has slots, but we should not access them"
			format: 1 "object with instance variables"
			classIndex: objectBuilder nextOrdinaryClassIndex ].
	aRAObject typeTag = 1 ifTrue: [ 
		^ objectBuilder integerObjectOfTwoComplement: aRAObject integerValue ].
	self halt.
]

{ #category : #testing }
RAConstraintSolution >> isEmpty [
	
	^ path isEmpty
]

{ #category : #testing }
RAConstraintSolution >> isFailure [
	
	^ path failure
]

{ #category : #accessing }
RAConstraintSolution >> numberOfArguments: anInteger [ 
	
	numberOfArguments := anInteger
]

{ #category : #accessing }
RAConstraintSolution >> objectBuilder: builder [ 
	objectBuilder := builder
]

{ #category : #testing }
RAConstraintSolution >> parameterNames [
	
	^ ((numberOfArguments "0 based because of Receiver" to: 0 by: -1)
		collect: [ :e | 'stack_', e asString, '_type' ]),
			((numberOfArguments "0 based because of Receiver" to: 0 by: -1)
				collect: [ :e | 'stack_', e asString, '_value' ])
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
	aStream nextPut: $(.
	self parameterNames
		do: [ :e | 
			aStream print: e.
			aStream nextPut: $=.
			aStream print: (self valueOf: e). ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $)
]

{ #category : #'value-accessing' }
RAConstraintSolution >> receiver [
	
	^ self stackValue: numberOfArguments
]

{ #category : #'value-accessing' }
RAConstraintSolution >> receiverTags [
	
	^ (self stackValue: numberOfArguments) typeTag
]

{ #category : #accessing }
RAConstraintSolution >> solver [

	^ solver
]

{ #category : #accessing }
RAConstraintSolution >> solver: anObject [

	solver := anObject
]

{ #category : #'value-accessing' }
RAConstraintSolution >> stackValue: anInteger [ 
	
	| name |
	name := 'stack_', anInteger asString.
	^ (RAObject named: name)
		typeTag: (self valueOf: name, '_type');
		integerValue: (self valueOf: name, '_value');
		yourself
]

{ #category : #accessing }
RAConstraintSolution >> valueOf: aString [ 
	
	| value |
	value := variables detect: [ :e | e name = aString ] ifNone: [  ^ 0 ].
	value value ifNil: [ ^ 666 "Unknown" ].
	^ value value ceiling
]

{ #category : #accessing }
RAConstraintSolution >> variables [

	^ variables
]

{ #category : #accessing }
RAConstraintSolution >> variables: anObject [

	variables := anObject
]
