Class {
	#name : #RATestInterpreter,
	#superclass : #CogVMSimulatorLSB,
	#category : #'Ranger-Tests'
}

{ #category : #'as yet unclassified' }
RATestInterpreter >> primitiveNoConditional [

	<numberOfArguments: 0>
	
	self pop: 1 thenPush: 10
]

{ #category : #'as yet unclassified' }
RATestInterpreter >> primitiveSimpleConditional [

	<numberOfArguments: 0>
	
	| result |
	result := self stackTop = 0 ifTrue: [ 42 ] ifFalse: [ 17 ].
	self pop: 1 thenPush: result
]
