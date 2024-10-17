Class {
	#name : 'RAConcolicCase',
	#superclass : 'Object',
	#instVars : [
		'isa',
		'wordsize',
		'primitive',
		'generator',
		'solution',
		'primitiveAddress',
		'compilationResult',
		'endInstruction',
		'aTest'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'running' }
RAConcolicCase >> execute [

	solution exitCondition executeTest: self
]

{ #category : 'executing' }
RAConcolicCase >> executePrimitiveFailure: aRAPrimitiveFailure [ 

	aTest runFrom: primitiveAddress until: endInstruction address
]

{ #category : 'executing' }
RAConcolicCase >> executeUntilReturn [

	aTest runFrom: primitiveAddress until: aTest callerAddress.
	aTest
		assert: aTest machineSimulator receiverRegisterValue
		equals: (aTest objectBuilder instantiate: solution result)
]

{ #category : 'accessing' }
RAConcolicCase >> generator [

	^ generator
]

{ #category : 'accessing' }
RAConcolicCase >> generator: anObject [

	generator := anObject
]

{ #category : 'testing' }
RAConcolicCase >> isInvalidMemoryAccessInvalid [
	
	^ false
]

{ #category : 'accessing' }
RAConcolicCase >> isa [

	^ isa
]

{ #category : 'accessing' }
RAConcolicCase >> isa: anObject [

	isa := anObject
]

{ #category : 'running' }
RAConcolicCase >> prepareAutoCall [

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
RAConcolicCase >> primitive [

	^ primitive
]

{ #category : 'accessing' }
RAConcolicCase >> primitive: anObject [

	primitive := anObject
]

{ #category : 'accessing' }
RAConcolicCase >> primitiveReceiver [

	^ solution inputConstraints operandStack last
]

{ #category : 'executing' }
RAConcolicCase >> receiverTags [

	^ self primitiveReceiver typeTag value ifNil: [ 0 ]
]

{ #category : 'running' }
RAConcolicCase >> runOn: theTest [

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

{ #category : 'accessing' }
RAConcolicCase >> solution [

	^ solution
]

{ #category : 'accessing' }
RAConcolicCase >> solution: anObject [

	solution := anObject
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize [

	^ wordsize
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize: anObject [

	wordsize := anObject
]
