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
RAPrimitiveAutoTest class >> testParameters [
	| suite matrix interpreter primitives |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.
	matrix := ParametrizedTestMatrix new.
	
	"Find the list of primitives to test"
	interpreter := suite anyOne setUp; interpreter.
	primitives := (interpreter class primitiveTable withIndexCollect: [ :e :i | i -> e ])
		select: [ :e | 
			e value isSymbol
				and: [(interpreter class lookupSelector: e value) hasPragmaNamed: #numberOfArguments:] ]
		thenCollect: [ :e |
			{ 
				e value.
				(interpreter cogit class primitiveTable at: e key - 1) primitiveGenerator.
			}
		].

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	primitives do: [ :p | | architectures solutions |
		architectures := {
		{ #ISA -> #'aarch64'. #wordSize -> 8}.
		{ #ISA -> #'IA32'. #wordSize -> 4}.
		{ #ISA -> #'X64'. #wordSize -> 8}.
		{ #ISA -> #'ARMv5'. #wordSize -> 4}}.
		architectures do: [ :arch |
			interpreter :=	(suite detect: [:e | 
				e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
				e wordSize = arch second value]) 
					setUp; interpreter.
			solutions := RAPathExplorer explore: p first on: interpreter.
			solutions do: [ :e |
				matrix addCase: {
					arch first.
					arch second.
					#primitive -> p first.
					#generator -> p second.
					#solution -> e } ] ] ].
	
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
		prepareStackForSendReceiver: (objectBuilder instantiate: solution receiver)
		arguments: (solution arguments collect: [:e | objectBuilder instantiate: e ]).
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
	solution objectBuilder: self.
	cogit receiverTags: solution receiverTags.
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
		compilationResult := cogit objectRepresentation perform: generator.
		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := cogit Stop ]
		bytecodes: 15.
	self prepareAutoCall.
	self execute.
]