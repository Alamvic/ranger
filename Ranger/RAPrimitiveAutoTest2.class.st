Class {
	#name : #RAPrimitiveAutoTest2,
	#superclass : #VMSimpleStackBasedCogitAbstractTest,
	#instVars : [
		'solution',
		'endInstruction',
		'primitiveAddress',
		'generator',
		'primitive',
		'objectBuilder'
	],
	#category : #Ranger
}

{ #category : #'building suites' }
RAPrimitiveAutoTest2 class >> testParameters [

	| interpreter solutions matrix primitives suite interpreter32 interpreter64 |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.
	interpreter32 := (suite detect: [:e | e setUp. e wordSize = 4]) interpreter.
	interpreter64 := (suite detect: [:e | e setUp. e wordSize = 8]) interpreter.
	matrix := ParametrizedTestMatrix new.
	primitives := #( 
		(primitiveAdd 			genPrimitiveAdd)
		(primitiveSubtract 	genPrimitiveSubtract) ).
	primitives do: [ :p | | architectures |
		architectures := {
		{ #ISA -> #'aarch64'. #wordSize -> 8}.
		{ #ISA -> #'IA32'. #wordSize -> 4}.
		{ #ISA -> #'X64'. #wordSize -> 8}.
		{ #ISA -> #'ARMv5'. #wordSize -> 4}}.
		architectures do: [ :arch |
			interpreter := arch second value = 4
				ifTrue: [ interpreter32 ]
				ifFalse: [ interpreter64 ].
			solutions := RAPathExplorer explore: p first on: interpreter.	
			solutions do: [ :e |
				matrix addCase: {
					arch first.
					arch second.
					#primitive -> p first.
					#generator -> p second.
					#solution -> e} ] ] ].
	
	^ super testParameters * matrix
]

{ #category : #building }
RAPrimitiveAutoTest2 >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #running }
RAPrimitiveAutoTest2 >> execute [

	| stopAddress |
	stopAddress := solution isFailure
		ifTrue: [ endInstruction address ]
		ifFalse: [ callerAddress ].
	self runFrom: primitiveAddress until: stopAddress
]

{ #category : #accessing }
RAPrimitiveAutoTest2 >> generator: aString [ 
	generator := aString
]

{ #category : #building }
RAPrimitiveAutoTest2 >> integerObjectOfTwoComplement: twoComplement [ 
	
	| pharoInteger |
	pharoInteger := twoComplement integerOfTwoComplementOfBitSize: memory numSmallIntegerBits.
	^ memory integerObjectOf: pharoInteger
]

{ #category : #running }
RAPrimitiveAutoTest2 >> prepareAutoCall [

	self
		prepareStackForSendReceiver: (objectBuilder instantiate: solution receiver)
		arguments: (solution arguments collect: [:e | objectBuilder instantiate: e ]).
]

{ #category : #accessing }
RAPrimitiveAutoTest2 >> primitive: aString [ 
	
	primitive := aString
]

{ #category : #running }
RAPrimitiveAutoTest2 >> setUp [

	super setUp.
	solution objectBuilder: self.
	cogit receiverTags: solution receiverTags.
	objectBuilder := RAObjectBuilder new
		interpreter: interpreter;
		nextIndex: nextIndex;
		yourself
]

{ #category : #running }
RAPrimitiveAutoTest2 >> solution: aSolution [

	solution := aSolution
]

{ #category : #running }
RAPrimitiveAutoTest2 >> testPrimitive [

	primitiveAddress := self compile: [ 
		cogit objectRepresentation perform: generator.
		"If the primitive fails it continues, so we need to have an instruction to detect the end"
		endInstruction := cogit Stop ].
	self prepareAutoCall.
	self execute.
]
