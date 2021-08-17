Class {
	#name : #RABytecodeAutoTest,
	#superclass : #VMSimpleStackBasedCogitAbstractTest,
	#instVars : [
		'solution',
		'bytecode',
		'endInstruction',
		'objectBuilder',
		'compilationResult',
		'methodAddress'
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

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	(76 to: 83)
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

	^ matrix
]

{ #category : #building }
RABytecodeAutoTest >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #accessing }
RABytecodeAutoTest >> bytecode [

	^ bytecode
]

{ #category : #accessing }
RABytecodeAutoTest >> bytecode: anObject [

	bytecode := anObject
]

{ #category : #running }
RABytecodeAutoTest >> execute [

	self runFrom: methodAddress until: callerAddress.
	self
		assert: machineSimulator receiverRegisterValue
		equals: (objectBuilder instantiate: solution result)
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
		self pushAddress: (objectBuilder instantiate: aLocalValue) ].
	
	solution inputConstraints operandStack do: [ :aStackValue | 
		self pushAddress: (objectBuilder instantiate: aStackValue) ].
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

{ #category : #running }
RABytecodeAutoTest >> runCaseManaged [ 

	^ self runCase
]

{ #category : #running }
RABytecodeAutoTest >> setUp [

	super setUp.
	self installFloatClass.
	memory classExternalAddress: (self
			 newClassInOldSpaceWithSlots: 0
			 instSpec: (memory byteFormatForNumBytes: 0)).


	cogit receiverTags: (solution inputConstraints receiver typeTag value ifNil: [ 0 ]).
	objectBuilder := RAObjectBuilder new
		                 interpreter: interpreter;
		                 nextIndex: nextIndex;
		                 yourself
]

{ #category : #running }
RABytecodeAutoTest >> solution: aSolution [

	solution := aSolution
]

{ #category : #running }
RABytecodeAutoTest >> testBytecode [

	solution isInvalid ifTrue: [ ^ self ].
	
	self assert: (solution inputConstraints operandStackSize value ifNil: [ 0 ]) = 0.
	methodAddress := self compile: [ | descriptor result |
		cogit needsFrame: true.
		cogit methodObj: (objectBuilder instantiate: solution inputConstraints method).
		cogit byte0: bytecode.
		cogit bytecodePC: 0.
		cogit endPC: 0.
		cogit methodOrBlockNumArgs: solution inputConstraints arguments size. 

		descriptor := cogit generatorAt: bytecode.
		result := cogit perform: descriptor generator.
		solution exitCondition returnResultInto: cogit
	] bytecodes: 15.

	self prepareAutoCall.
	self execute.
]
