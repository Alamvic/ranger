Class {
	#name : #RAPrimitiveAutoTest,
	#superclass : #VMSimpleStackBasedCogitAbstractTest,
	#instVars : [
		'solution',
		'endInstruction',
		'primitiveAddress',
		'generator',
		'primitive',
		'objectBuilder',
		'compilationResult'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'building suites' }
RAPrimitiveAutoTest class >> exploreCasesForBytecode: aBytecode withWordSize: aWordSize [

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
		  explore: (RABytecodeConcolicCase new
				   bytecode: aBytecode;
				   vm: interpreter;
				   yourself)
		  vmBuildingBlock: [ 
			  (suite detect: [ :e | 
					   e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
					   e wordSize = aWordSize ])
				  setUp;
				  interpreter ]
]

{ #category : #'building suites' }
RAPrimitiveAutoTest class >> exploreCasesForPrimitive: aPrimitive withWordSize: aWordSize [

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
		  explore: (RAPrimitiveConcolicCase new
				   selector: aPrimitive;
				   yourself)
		  vmBuildingBlock: [ 
		  (suite detect: [ :e | 
				   e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
				   e wordSize = aWordSize ])
			  setUp;
			  interpreter ]
]

{ #category : #'building suites' }
RAPrimitiveAutoTest class >> testParameters [

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
					             explore: (RAPrimitiveConcolicCase new
							              selector: p first;
							              yourself)
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
RAPrimitiveAutoTest >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #running }
RAPrimitiveAutoTest >> execute [

	| stopAddress |
	stopAddress := solution isFailure
		ifTrue: [ 
			compilationResult = UnimplementedPrimitive ifTrue: [ 
				"Its ok, do not execute anything. This path was a failure and was not compiled"
				^ self ].
			endInstruction address ]
		ifFalse: [ callerAddress ].
	
	self runFrom: primitiveAddress until: stopAddress
]

{ #category : #accessing }
RAPrimitiveAutoTest >> generator: aString [ 
	generator := aString
]

{ #category : #running }
RAPrimitiveAutoTest >> prepareAutoCall [

	self
		prepareStackForSendReceiver: (objectBuilder instantiate: solution receiver) first
		arguments: (solution arguments collect: [:e | (objectBuilder instantiate: e) first ]).
]

{ #category : #accessing }
RAPrimitiveAutoTest >> primitive: aString [ 
	
	primitive := aString
]

{ #category : #running }
RAPrimitiveAutoTest >> runCaseManaged [ 

	^ self runCase
]

{ #category : #running }
RAPrimitiveAutoTest >> setUp [

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
RAPrimitiveAutoTest >> solution: aSolution [

	solution := aSolution
]

{ #category : #running }
RAPrimitiveAutoTest >> testPrimitive [

	primitiveAddress := self compile: [ 
		compilationResult := cogit objectRepresentation perform: generator "#genPrimitiveBitShift".
		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := cogit Stop ]
		bytecodes: 15.

	self prepareAutoCall.
	self execute.
]
