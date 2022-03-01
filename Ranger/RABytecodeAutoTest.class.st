Class {
	#name : #RABytecodeAutoTest,
	#superclass : #RAAbstractAutoTest,
	#instVars : [
		'bytecode',
		'endInstruction',
		'compilationResult',
		'methodAddress',
		'jitCompilerClass'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'building suites' }
RABytecodeAutoTest class >> testParameters [

	| suite matrix interpreter |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.
	matrix := ParametrizedTestMatrix new.

	"Find the list of primitives to test"
	interpreter := suite anyOne
		               setUp;
		               interpreter.

	"force the progress bar"
	(1 to: 1) do: [ :e | ] displayingProgress: [ :e | "nothing" ].
	
	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	(1 to: 175)
		do: [ :bytecode | 
			| architectures solutions |
			architectures := { 
				                 { 
					                 (#ISA -> #IA32).
					                 (#wordSize -> 4) }.
				                 "{ #ISA -> #'X64'. #wordSize -> 8}."
				                 { 
					                 (#ISA -> #ARMv5).
					                 (#wordSize -> 4) } }.
			"{ #ISA -> #'aarch64'. #wordSize -> 8}."
			architectures do: [ :arch | 
				| theSetUpTest |
				theSetUpTest := suite detect: [ :e | 
					                e parametersToUse do: [ :aParameter | 
						                aParameter applyTo: e ].
					                e wordSize = arch second value ].
				interpreter := theSetUpTest
					               setUp;
					               interpreter.
				solutions := RAPathExplorer new
					             failOnError: false;
					             explore: (RABytecodeConcolicCase new
	              	              	vm: interpreter;
	              	              	bytecode: bytecode;
											yourself)
					             vmBuildingBlock: [ 
						             theSetUpTest
							             setUp;
							             interpreter ].
				
				solutions do: [ :e | 
					matrix addCase: { 
							arch first.
							arch second.
							(#bytecode -> bytecode).
							(#solution -> e) } ] ] ]
		displayingProgress: [ :bytecode | bytecode asString ].

	^ matrix * (ParametrizedTestMatrix new
		forSelector: #jitCompilerClass addOptions: {SimpleStackBasedCogit};
		yourself)
]

{ #category : #accessing }
RABytecodeAutoTest >> bytecode [

	^ bytecode
]

{ #category : #accessing }
RABytecodeAutoTest >> bytecode: anObject [

	bytecode := anObject
]

{ #category : #compiling }
RABytecodeAutoTest >> compileEndInstructionForPrimitiveFailure: aRAPrimitiveFailure [ 
	
	"In bytecodes, primitive failures should be ignored"
	self compileEndInstructionForSuccess: aRAPrimitiveFailure
]

{ #category : #compiling }
RABytecodeAutoTest >> compileEndInstructionForSuccess: aRASuccess [
	
	"I'm a success and my value has been pushed to the operand stack.
	Make a return top"
	cogit genReturnTopFromMethod
]

{ #category : #running }
RABytecodeAutoTest >> execute [

	solution exitCondition executeTest: self
]

{ #category : #executing }
RABytecodeAutoTest >> executePrimitiveFailure: aRAPrimitiveFailure [ 
	
	"If this is a primitive failure during a bytecode instruction, this means it was a success!
	Actually, this means that the bytecode tried to execute a primitive inside, it failed, and tried something else.
	If this were a real failure case, the exit status would be another one (like send exit)"
	self executeUntilReturn
]

{ #category : #executing }
RABytecodeAutoTest >> executeUntilReturn [

	self runFrom: methodAddress until: callerAddress.
	self
		assert: machineSimulator receiverRegisterValue
		equals: (objectBuilder instantiate: solution result)
]

{ #category : #executing }
RABytecodeAutoTest >> executeUntilSendTrampoline [

	self runFrom: methodAddress until: sendTrampolineStop address.

	self
		assert: machineSimulator receiverRegisterValue
		equals: (objectBuilder instantiate: solution exitCondition messageReceiver).
	self
		assert: machineSimulator classRegisterValue
		equals: (objectBuilder instantiate: solution exitCondition messageSelector)
]

{ #category : #testing }
RABytecodeAutoTest >> isInvalidMemoryAccessInvalid [
	
	"Bytecode assume all objects are correct... Otherwise it's a bytecode sequence problem"
	^ true
]

{ #category : #accessing }
RABytecodeAutoTest >> jitCompilerClass [

	^ jitCompilerClass
]

{ #category : #accessing }
RABytecodeAutoTest >> jitCompilerClass: aClass [ 
	
	jitCompilerClass := aClass
]

{ #category : #running }
RABytecodeAutoTest >> prepareAutoCall [

	| receiver |
	receiver := objectBuilder instantiate: solution inputConstraints receiver.
	self
		prepareStackForSendReceiver: receiver
		arguments: (solution inputConstraints arguments collect: [:e | (objectBuilder instantiate: e) ]).
	
	"previous frame"
	self pushAddress: self machineSimulator framePointerRegisterValue.
	self machineSimulator framePointerRegisterValue: self machineSimulator smalltalkStackPointerRegisterValue.
	
	self pushAddress: (objectBuilder instantiate: solution inputConstraints method).
	self pushAddress: 0. "context"
	self pushAddress: receiver.

	solution inputConstraints locals do: [ :aLocalValue | 
		self pushAddress: (objectBuilder instantiate: aLocalValue) ]
]

{ #category : #running }
RABytecodeAutoTest >> prepareCall [

	machineSimulator hasLinkRegister 
		ifTrue: [ 
			"The caller IP in ARM is in the linkRegister"
			machineSimulator linkRegisterValue: callerAddress ].
	"I need to push the caller IP to make a correct frame"
	self pushAddress:  callerAddress.

]

{ #category : #accessing }
RABytecodeAutoTest >> receiverTags [

	^ solution inputConstraints receiver typeTag value ifNil: [ 0 ]
]

{ #category : #running }
RABytecodeAutoTest >> testBytecode [

	(solution isInvalidIn: self) ifTrue: [ ^ self ].

	methodAddress := self compile: [ | descriptor result |
		cogit needsFrame: true.
		cogit methodObj: (objectBuilder instantiate: solution inputConstraints method).
		cogit byte0: bytecode.
		cogit bytecodePC: 0.
		cogit endPC: 0.
		solution inputConstraints operandStack reversed do: [ :aStackValue | 
			cogit genPushLiteral: (objectBuilder instantiate: aStackValue) ].

		descriptor := cogit generatorAt: bytecode.
		result := cogit perform: descriptor generator.
		solution exitCondition returnResultInto: self
	] bytecodes: 15.

	self prepareAutoCall.
	self execute.
]
