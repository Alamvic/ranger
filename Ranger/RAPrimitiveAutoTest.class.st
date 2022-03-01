Class {
	#name : #RAPrimitiveAutoTest,
	#superclass : #RAAbstractAutoTest,
	#instVars : [
		'endInstruction',
		'primitiveAddress',
		'generator',
		'primitive',
		'compilationResult'
	],
	#category : #'Ranger-Exploring'
}

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
		  failOnError: true;
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



	"primitives := #( (#primitiveAt #genPrimitiveAt))."


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

{ #category : #running }
RAPrimitiveAutoTest >> execute [

	solution exitCondition executeTest: self
]

{ #category : #executing }
RAPrimitiveAutoTest >> executePrimitiveFailure: aRAPrimitiveFailure [ 

	self runFrom: primitiveAddress until: endInstruction address
]

{ #category : #executing }
RAPrimitiveAutoTest >> executeUntilReturn [

	self runFrom: primitiveAddress until: callerAddress.
	self
		assert: machineSimulator receiverRegisterValue
		equals: (objectBuilder instantiate: solution result)
]

{ #category : #accessing }
RAPrimitiveAutoTest >> generator: aString [ 
	generator := aString
]

{ #category : #testing }
RAPrimitiveAutoTest >> isInvalidMemoryAccessInvalid [
	
	^ false
]

{ #category : #accessing }
RAPrimitiveAutoTest >> prepareAutoCall [

	| receiver primitiveReceiver primitiveArguments |
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

	primitiveReceiver := objectBuilder instantiate: self primitiveReceiver.
	primitiveArguments := solution inputConstraints operandStack allButLast
		collect: [ :e | objectBuilder instantiate: e].
	self
		prepareStackForSendReceiver: primitiveReceiver
		arguments: primitiveArguments
]

{ #category : #accessing }
RAPrimitiveAutoTest >> primitive: aString [ 
	
	primitive := aString
]

{ #category : #accessing }
RAPrimitiveAutoTest >> primitiveReceiver [

	^ solution inputConstraints operandStack last
]

{ #category : #executing }
RAPrimitiveAutoTest >> receiverTags [

	^ self primitiveReceiver typeTag value ifNil: [ 0 ]
]

{ #category : #running }
RAPrimitiveAutoTest >> solution: aSolution [

	solution := aSolution
]

{ #category : #running }
RAPrimitiveAutoTest >> testPrimitive [

	(solution isInvalidIn: self) ifTrue: [ ^ self ].

	primitiveAddress := self compile: [ 
		compilationResult := cogit objectRepresentation perform: generator.
		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := cogit Stop ]
		bytecodes: 15.

	self prepareAutoCall.

	self execute.
]
