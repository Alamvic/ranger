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

	aTest runFrom: primitiveAddress until: endInstruction address
]

{ #category : 'executing' }
RAConcolicPrimitiveCase >> executeUntilReturn [

	aTest runFrom: primitiveAddress until: aTest callerAddress.
	aTest
		assert: aTest machineSimulator receiverRegisterValue
		equals: (aTest objectBuilder instantiate: solution result)
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

	receiver := aTest objectBuilder instantiate: solution inputConstraints receiver.
	aTest
		prepareStackForSendReceiver: receiver
		arguments: (solution inputConstraints arguments collect: [:e | (aTest objectBuilder instantiate: e) ]).
	
	"previous frame"
	aTest pushAddress: aTest machineSimulator framePointerRegisterValue.
	aTest machineSimulator framePointerRegisterValue: aTest machineSimulator smalltalkStackPointerRegisterValue.
	
	aTest pushAddress: (aTest objectBuilder instantiate: solution inputConstraints method).
	aTest pushAddress: 0. "context"
	aTest pushAddress: receiver.

	solution inputConstraints locals do: [ :aLocalValue | 
		aTest pushAddress: (aTest objectBuilder instantiate: aLocalValue) ].

	primitiveReceiver := aTest objectBuilder instantiate: self primitiveReceiver.
	primitiveArguments := solution inputConstraints operandStack allButLast
		collect: [ :e | aTest objectBuilder instantiate: e].
	aTest
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
RAConcolicPrimitiveCase >> runOn: theTest [

	"Setting test instance"
	aTest := theTest.
	aTest setUp: self.
	
	(self solution isInvalidIn: self) ifTrue: [ ^ self ].

	primitiveAddress := theTest compile: [
		compilationResult := aTest cogit objectRepresentation perform: self generator.

		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := aTest cogit Stop
	] bytecodes: 15.

	self prepareAutoCall.

	self execute.
]
