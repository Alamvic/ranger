Class {
	#name : #RATestingInterpreter,
	#superclass : #CogVMSimulatorLSB,
	#category : #'Ranger-Tests'
}

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveCheckPairOfIntegers [

	| stackArgument stackReceiver |
	stackArgument := self stackValue: 0.
	stackReceiver := self stackValue: 1.
	
	(objectMemory isIntegerObject: stackArgument)
		ifFalse: [ self primitiveFail ].
		
	(objectMemory isIntegerObject: stackReceiver)
		ifFalse: [ self primitiveFail ].

	self pop: 1 thenPush: (objectMemory booleanObjectOf: self successful)
]

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveCheckPairOfIntegers2 [

	| stackArgument stackReceiver |
	stackArgument := self stackValue: 0.
	stackReceiver := self stackValue: 1.
	
	(objectMemory isIntegerObject: stackArgument)
		ifFalse: [ self primitiveFail ].
		
	(objectMemory isIntegerObject: stackReceiver)
		ifFalse: [ self primitiveFail ].

	self pop: 1 thenPushBool: self successful
]

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveReturningInteger [

	"Accessing the operand stack in the frame will force to have a frame with a filled stack"
	| stackTop |
	stackTop := self stackValue: 0.
	
	(objectMemory isIntegerObject: stackTop)
		ifFalse: [ ^ self primitiveFail ].

	self pop: 1 thenPush: stackTop
]

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveReturningReceiver [

	"Accessing the operand stack in the frame will force to have a frame with a filled stack"
	| stackTop |
	stackTop := self stackValue: 0.

	self pop: 1 thenPush: stackTop
]

{ #category : #'as yet unclassified' }
RATestingInterpreter >> primitiveReturningReceiverPlusOne [

	"Accessing the operand stack in the frame will force to have a frame with a filled stack"
	| stackTop |
	stackTop := self stackValue: 0.

	(objectMemory isIntegerObject: stackTop)
		ifFalse: [ ^ self primitiveFail ].

	self pop: 1 thenPush: (objectMemory integerObjectOf: (objectMemory integerValueOf: stackTop) + 1)
]

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
