Class {
	#name : #RABytecodeAutoTest,
	#superclass : #VMSimpleStackBasedCogitAbstractTest,
	#instVars : [
		'solution',
		'endInstruction',
		'generator',
		'primitive',
		'objectBuilder',
		'compilationResult',
		'methodAddress'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'building suites' }
RABytecodeAutoTest class >> exploreCasesForBytecode: aBytecode withWordSize: aWordSize [

	| suite interpreter |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.

	"Find the list of primitives to test"
	interpreter := suite anyOne
		               setUp;
		               interpreter.

	interpreter := (suite detect: [ :e | 
			                e parametersToUse do: [ :aParameter | 
					                aParameter applyTo: e ].
			                e wordSize = aWordSize ])
		               setUp;
		               interpreter.
	^ RAPathExplorer new
		  failOnError: true;
		  exploreBytecode: aBytecode on: interpreter vmBuildingBlock: [ 
			  (suite detect: [ :e | 
					   e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
					   e wordSize = aWordSize ])
				  setUp;
				  interpreter ]
]

{ #category : #'building suites' }
RABytecodeAutoTest class >> exploreCasesForPrimitive: aPrimitive withWordSize: aWordSize [

	| suite interpreter |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.

	"Find the list of primitives to test"
	interpreter := suite anyOne
		               setUp;
		               interpreter.

	interpreter := (suite detect: [ :e | 
			                e parametersToUse do: [ :aParameter | 
					                aParameter applyTo: e ].
			                e wordSize = aWordSize ])
		               setUp;
		               interpreter.
	^ RAPathExplorer new
		  failOnError: false;
		  explorePrimitive: aPrimitive on: interpreter vmBuildingBlock: [ 
			  (suite detect: [ :e | 
					   e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
					   e wordSize = aWordSize ])
				  setUp;
				  interpreter ]
]

{ #category : #'building suites' }
RABytecodeAutoTest class >> testParameters [

	| suite matrix interpreter primitives |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.
	matrix := ParametrizedTestMatrix new.

	"Find the list of primitives to test"
	interpreter := suite anyOne
		               setUp;
		               interpreter.
	primitives := (interpreter class primitiveTable withIndexCollect: [ 
		               :e 
		               :i | i -> e ])
		              select: [ :e | 
			              e value isSymbol and: [ 
				              ((interpreter class lookupSelector: e value) 
					               hasPragmaNamed: #numberOfArguments:) and: [ 
					              (interpreter cogit class primitiveTable at:
						               e key - 1) primitiveGenerator notNil ] ] ]
		              thenCollect: [ :e | 
			              { 
				              e value.
				              (interpreter cogit class primitiveTable at:
					               e key - 1) primitiveGenerator } ].

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	primitives
		do: [ :p | 
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
					             explorePrimitive: p first
					             on: interpreter
					             vmBuildingBlock: [ 
						             theSetUpTest
							             setUp;
							             interpreter ].
				solutions do: [ :e | 
					matrix addCase: { 
							arch first.
							arch second.
							(#primitive -> p first).
							(#generator -> p second).
							(#solution -> e) } ] ] ]
		displayingProgress: [ :p | (p first -> p second) asString ].

	^ matrix
]

{ #category : #building }
RABytecodeAutoTest >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #running }
RABytecodeAutoTest >> execute [

	| stopAddress |
	stopAddress := solution isFailure
		ifTrue: [ 
			compilationResult = UnimplementedPrimitive ifTrue: [ 
				"Its ok, do not execute anything. This path was a failure and was not compiled"
				^ self ].
			endInstruction address ]
		ifFalse: [ callerAddress ].
	
	self runFrom: methodAddress until: stopAddress
]

{ #category : #accessing }
RABytecodeAutoTest >> generator: aString [ 
	generator := aString
]

{ #category : #running }
RABytecodeAutoTest >> prepareAutoCall [

	self
		prepareStackForSendReceiver: (objectBuilder instantiate: solution receiver) first
		arguments: (solution arguments collect: [:e | (objectBuilder instantiate: e) first ]).
]

{ #category : #accessing }
RABytecodeAutoTest >> primitive: aString [ 
	
	primitive := aString
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


	cogit receiverTags: (solution receiverTags value ifNil: [ 0 ]).
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
RABytecodeAutoTest >> testPrimitive [

	methodAddress := self compile: [ 
		1halt.
		"should push before so many elements as the bytecode needs"
		compilationResult := cogit objectRepresentation perform: generator
		"should return top if the bytecode returns something to be able to test it!" ]
		bytecodes: 15.

	self prepareAutoCall.
	self execute.
]
