Class {
	#name : 'RAConcolicBytecodeCase',
	#superclass : 'RAConcolicCase',
	#instVars : [
		'bytecode',
		'methodAddress'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'accessing' }
RAConcolicBytecodeCase >> bytecode: anObject [

	bytecode := anObject.
]

{ #category : 'compiling' }
RAConcolicBytecodeCase >> compileEndInstructionForPrimitiveFailure: aRAPrimitiveFailure [ 
	
	"In bytecodes, primitive failures should be ignored"
	self compileEndInstructionForSuccess: aRAPrimitiveFailure
]

{ #category : 'compiling' }
RAConcolicBytecodeCase >> compileEndInstructionForSuccess: aRASuccess [
	
	"I'm a success and my value has been pushed to the operand stack.
	Make a return top"
	testToExecute cogit genReturnTopFromMethod
]

{ #category : 'executing' }
RAConcolicBytecodeCase >> executePrimitiveFailure: aRAPrimitiveFailure [ 
	
	"If this is a primitive failure during a bytecode instruction, this means it was a success!
	Actually, this means that the bytecode tried to execute a primitive inside, it failed, and tried something else.
	If this were a real failure case, the exit status would be another one (like send exit)"
	testToExecute executeUntilReturn
]

{ #category : 'executing' }
RAConcolicBytecodeCase >> executeUntilReturn [

	testToExecute runFrom: methodAddress until: testToExecute callerAddress.
	testToExecute
		assert: testToExecute machineSimulator receiverRegisterValue
		equals: (testToExecute objectBuilder instantiate: solution result)
]

{ #category : 'executing' }
RAConcolicBytecodeCase >> executeUntilSendTrampoline [

	testToExecute runFrom: methodAddress until: testToExecute sendTrampolineStop address.

	testToExecute
		assert: testToExecute machineSimulator receiverRegisterValue
		equals: (testToExecute objectBuilder instantiate: solution exitCondition messageReceiver).
	testToExecute
		assert: testToExecute machineSimulator classRegisterValue
		equals: (testToExecute objectBuilder instantiate: solution exitCondition messageSelector)
]

{ #category : 'testing' }
RAConcolicBytecodeCase >> isInvalidMemoryAccessInvalid [
	
	"Bytecode assume all objects are correct... Otherwise it's a bytecode sequence problem"
	^ true
]

{ #category : 'running' }
RAConcolicBytecodeCase >> prepareAutoCall [

	| receiver |
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
		testToExecute pushAddress: (testToExecute objectBuilder instantiate: aLocalValue) ]
]

{ #category : 'executing' }
RAConcolicBytecodeCase >> receiverTags [

	^ solution inputConstraints receiver typeTag value ifNil: [ 0 ]
]

{ #category : 'as yet unclassified' }
RAConcolicBytecodeCase >> replicate: sol from: runner [

	^ runner bytecodeCaseBy: bytecode  with: sol  arch: self arch
]

{ #category : 'running' }
RAConcolicBytecodeCase >> runOn: aTest [

	"Setting test instance"
	| cogit |
	testToExecute := aTest.
	testToExecute setUp: self.
	
	(solution isInvalidIn: self) ifTrue: [ ^ self ].
	
	cogit := testToExecute cogit.
	
	methodAddress := aTest compile: [ | descriptor result |
		cogit needsFrame: true.
		cogit methodObj: (testToExecute objectBuilder instantiate: solution inputConstraints method).
		cogit byte0: bytecode.
		cogit bytecodePC: 0.
		cogit endPC: 0.
		solution inputConstraints operandStack reversed do: [ :aStackValue | 
			cogit genPushLiteral: (testToExecute objectBuilder instantiate: aStackValue) ].

		descriptor := cogit generatorAt: bytecode.
		result := cogit perform: descriptor generator.
		solution exitCondition returnResultInto: self
	] bytecodes: 15.

	self prepareAutoCall.
	self execute.

]
