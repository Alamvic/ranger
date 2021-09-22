Class {
	#name : #RATestingInterpreter,
	#superclass : #CogVMSimulatorLSB,
	#category : #'Ranger-Tests'
}

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveWithFrameAccess [

	"Accessing the operand stack in the frame will force to have a frame with a filled stack"
	| stackTop |
	stackTop := self stackValue: 0.

	self pop: 1 thenPush: 1
]

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveWithSinglePath [

	"This method should not access the frame to guarantee we have a single path"
	
	self push: 1
]
