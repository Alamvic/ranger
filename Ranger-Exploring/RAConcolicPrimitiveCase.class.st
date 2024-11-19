Class {
	#name : 'RAConcolicPrimitiveCase',
	#superclass : 'RAConcolicCase',
	#instVars : [
		'generator',
		'primitiveAddress',
		'primitive'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'executing' }
RAConcolicPrimitiveCase >> executePrimitiveFailure: aRAPrimitiveFailure [ 

	testToExecute runFrom: primitiveAddress until: endInstruction address
]

{ #category : 'executing' }
RAConcolicPrimitiveCase >> executeUntilReturn [

	testToExecute runFrom: primitiveAddress until: testToExecute callerAddress.
	testToExecute
		assert: testToExecute machineSimulator receiverRegisterValue
		equals: (testToExecute objectBuilder instantiate: solution result)
]

{ #category : 'accessing' }
RAConcolicPrimitiveCase >> generator [

	^ generator
]

{ #category : 'accessing' }
RAConcolicPrimitiveCase >> generator: anObject [

	generator := anObject
]

{ #category : 'running' }
RAConcolicPrimitiveCase >> prepareAutoCall [

	| receiver primitiveReceiver primitiveArguments |

	receiver := testToExecute objectBuilder instantiate: solution inputConstraints receiver.
	testToExecute
		prepareStackForSendReceiver: receiver
		arguments: (solution inputConstraints arguments collect: [:e | (testToExecute objectBuilder instantiate: e) ]).
	
	"previous frame"
	testToExecute pushAddress: testToExecute machineSimulator framePointerRegisterValue.
	testToExecute machineSimulator framePointerRegisterValue: testToExecute machineSimulator smalltalkStackPointerRegisterValue.
	
	testToExecute pushAddress: (testToExecute objectBuilder instantiate: solution inputConstraints method).
	testToExecute pushAddress: 0. "context"
	testToExecute pushAddress: receiver.

	solution inputConstraints locals do: [ :aLocalValue | 
		testToExecute pushAddress: (testToExecute objectBuilder instantiate: aLocalValue) ].

	primitiveReceiver := testToExecute objectBuilder instantiate: self primitiveReceiver.
	primitiveArguments := solution inputConstraints operandStack allButLast
		collect: [ :e | testToExecute objectBuilder instantiate: e].
	testToExecute
		prepareStackForSendReceiver: primitiveReceiver
		arguments: primitiveArguments
]

{ #category : 'accessing' }
RAConcolicPrimitiveCase >> primitive [

	^ primitive
]

{ #category : 'accessing' }
RAConcolicPrimitiveCase >> primitive: anObject [

	primitive := anObject
]

{ #category : 'accessing' }
RAConcolicPrimitiveCase >> primitiveReceiver [

	^ solution inputConstraints operandStack last
]

{ #category : 'executing' }
RAConcolicPrimitiveCase >> receiverTags [

	^ self primitiveReceiver typeTag value ifNil: [ 0 ]
]

{ #category : 'running' }
RAConcolicPrimitiveCase >> runOn: aTest [

	"Setting test instance"
	testToExecute := aTest.
	testToExecute setUp: self.
	
	(self solution isInvalidIn: self) ifTrue: [ ^ self ].

	primitiveAddress := aTest compile: [
		compilationResult := testToExecute cogit objectRepresentation perform: self generator.

		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := testToExecute cogit Stop
	] bytecodes: 15.

	self prepareAutoCall.

	self execute.
]
