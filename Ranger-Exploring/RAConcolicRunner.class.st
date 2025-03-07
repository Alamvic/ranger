Class {
	#name : 'RAConcolicRunner',
	#superclass : 'Object',
	#instVars : [
		'interpreter',
		'primitives',
		'bytecodes',
		'testCache',
		'interpreterCache',
		'shouldCache'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
RAConcolicRunner class >> primitivesFrom: interpreter [

	^ (interpreter class primitiveTable withIndexCollect: [ :elem :index |
		   index -> elem ])
		  select: [ :elem |
			  interpreter cogit class primitiveTable size > elem key and: [
				  elem value isSymbol and: [
					  (interpreter cogit class primitiveTable at: elem key)
						  primitiveGenerator notNil
					  ]
				  ]
			  ]
		  thenCollect: [ :elem | elem value ]
]

{ #category : 'as yet unclassified' }
RAConcolicRunner class >> runAndMeasure: cases with: testCase at: fileName [

	| coverageResult fails collector |
	collector := C2CoverageCollector new methods: CompilerCoverageCollector compilerMethods.
	coverageResult := collector runOn: [
		                  fails := RAConcolicRunner new
			                           run: cases
			                           with: testCase ].

	^ CompilerCoverageCollector
		generateCompilerCoverage: coverageResult
		withFails: fails
		at: fileName.

]

{ #category : 'tests' }
RAConcolicRunner >> bytecodeCaseBy: bytecode with: solution arch: arch [
	
	| case |
	case := RAConcolicBytecodeCase new.
	case isa: arch first.
	case wordsize: arch second.
	case bytecode: bytecode.
	case solution: solution.
	^ case
]

{ #category : 'tests' }
RAConcolicRunner >> bytecodesTestParameters [

	| matrix |
	matrix := ParametrizedTestMatrix new.

	"force the progress bar"
	(1 to: 1) do: [ :e |  ] displayingProgress: [ :e | "nothing" ].

	"Build the entire set of tests:
	 - for each architecture
	  - for each bytecode to test
	    - for each explored path
	      => build a test case"
	bytecodes do: [ :bytecode | | cases |
		cases := self casesForBytecode: bytecode.
		cases do: [ :case | matrix addCase: { (#case -> case) } ]
	] displayingProgress: [ :p | p value asString ].

	^ matrix * (ParametrizedTestMatrix new
		   forSelector: #jitCompilerClass
		   addOptions: { SimpleStackBasedCogit };
		   yourself)
]

{ #category : 'tests' }
RAConcolicRunner >> casesForAllBytecodes [
	
	^ self casesForBytecodes: bytecodes
]

{ #category : 'tests' }
RAConcolicRunner >> casesForAllPrimitives [
	
	^ self casesForPrimitives: primitives
]

{ #category : 'tests' }
RAConcolicRunner >> casesForBytecode: bytecode [

	^ self supportedArchitectures flatCollect: [ :arch |
		  | solutions |
		  solutions := self
			               solutionsForBytecode: bytecode
			               from: [ self newInterpreterForArchitecture: arch ].

		  solutions collect: [ :solution |
				self bytecodeCaseBy: bytecode with: solution arch: arch
			]
		]

]

{ #category : 'tests' }
RAConcolicRunner >> casesForBytecodes: _bytecodes [
	
	^ _bytecodes flatCollect: [ :bytecode | self casesForBytecode: bytecode ]
]

{ #category : 'tests' }
RAConcolicRunner >> casesForPrimitive: primitive [

	| generator |
	generator := self primitiveGeneratorFor: primitive.
	generator ifNil: [ ^ #(  ) ].

	^ self supportedArchitectures flatCollect: [ :arch |
		  | primitiveSolutions |
		  primitiveSolutions := self
			                        solutionsForPrimitive: primitive
			                        from: [
			                        		self newInterpreterForArchitecture: arch
											].

		  primitiveSolutions collect: [ :solution |
				self primitiveCaseBy: primitive with: solution arch: arch gen: generator
			]
		]
]

{ #category : 'tests' }
RAConcolicRunner >> casesForPrimitives: _primitives [
	
	^ _primitives flatCollect: [ :primitive |
		self casesForPrimitive: primitive
	]
]

{ #category : 'accessing' }
RAConcolicRunner >> compilerClass [

	^ self interpreter cogit class
]

{ #category : 'tests' }
RAConcolicRunner >> doNotCache [

	self shouldCache: false
]

{ #category : 'tests' }
RAConcolicRunner >> forceNewTestForCase: aCase fromPrototype: aTestPrototype [

	^ aTestPrototype
		  parametersToUse: {
				  (#case -> 1) asTestParameter.
				  aCase isa asTestParameter.
				  aCase wordsize asTestParameter };
		  setUp;
		  yourself
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> getReasonableCases: cases [ 

	| notNils initials withResults filtered |
	notNils := cases select: [ :case | case solution solver isNotNil ].
	
	initials := notNils select: [ :case | case solution solver = #initial ].
	
	withResults := (notNils difference: initials) select: [ :case | (case solution solver respondsTo: #result) and: case solution solver result isNotNil ].
	
	filtered := withResults select: [ :case | (case solution solver result beginsWith: '=====UNSATISFIABLE=====') not ].

	^ filtered, initials.
]

{ #category : 'tests' }
RAConcolicRunner >> initialize [

	super initialize.
	interpreter := self suite anyOne
		               setUp;
		               interpreter.
	primitives := self class primitivesFrom: interpreter.
	bytecodes := 1 to: 175.

	testCache := Dictionary new.
	interpreterCache := Dictionary new.
]

{ #category : 'tests' }
RAConcolicRunner >> interpreter [

	^ interpreter
]

{ #category : 'accessing' }
RAConcolicRunner >> interpreterClass [
	
	^ self interpreter class
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> mutateCases: cases with: mutators [
	
	| pathMutator |
	pathMutator := RAPathMutator new syntacticMutators: mutators.
	^ (cases inject: OrderedCollection new writeStream into: [ :stream :case |
			stream nextPutAll: (pathMutator mutateConcolicCase: case from: self); yourself
		]) contents
]

{ #category : 'tests' }
RAConcolicRunner >> newInterpreterForArchitecture: arch [

	| serializedByteArray |
	serializedByteArray := interpreterCache at: arch first value ifAbsentPut: [
		(self suite detect: [ :e |
		                e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
		                e wordSize = arch second value
						]) setUp interpreter serializeToByteArray
	].

	^ FLMaterializer new onStream: serializedByteArray readStream; materializeRoot
]

{ #category : 'tests' }
RAConcolicRunner >> newTestForCase: aCase fromPrototype: aTestPrototype [

	| serializedByteArray |

	self shouldCache ifFalse: [
		^ self forceNewTestForCase: aCase fromPrototype: aTestPrototype ].

	serializedByteArray := testCache at: aCase isa value ifAbsentPut: [
		                       (self
			                        forceNewTestForCase: aCase
			                        fromPrototype: aTestPrototype)
			                       serializeToByteArray ].

	^ FLMaterializer new
		  onStream: serializedByteArray readStream;
		  materializeRoot
]

{ #category : 'tests' }
RAConcolicRunner >> primitiveCaseBy: primitive with: solution arch: arch gen: generator [

	| case |
	case := RAConcolicPrimitiveCase new.
	case isa: arch first.
	case wordsize: arch second.
	case primitive: primitive.
	case generator: generator.
	case solution: solution.
	^ case
]

{ #category : 'tests' }
RAConcolicRunner >> primitiveGeneratorFor: primitive [

	| index |
	index := self primitiveIndex: primitive.
	(index <= 0 or: (index >= self compilerClass primitiveTable size)) ifTrue: [ ^ nil ].
	
	^ (self compilerClass primitiveTable at: index) primitiveGenerator
]

{ #category : 'tests' }
RAConcolicRunner >> primitiveIndex: primitive [

	"The table is on base 1 and should"
	^ (self interpreterClass primitiveTable indexOf: primitive) - 1.
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> primitives [

	^ (self interpreterClass primitiveTable withIndexCollect: [ :elem :index |
		   index -> elem ])
		  select: [ :elem |
			  self interpreter cogit class primitiveTable size > elem key and: [
				  elem value isSymbol and: [
					  (self interpreter cogit class primitiveTable at: elem key)
						  primitiveGenerator notNil
					  ]
				  ]
			  ]
		  thenCollect: [ :elem | elem value ]
]

{ #category : 'tests' }
RAConcolicRunner >> primitivesTestParameters [

	| matrix |
	matrix := ParametrizedTestMatrix new.

	"force the progress bar"
	(1 to: 1) do: [ :e |  ] displayingProgress: [ :e | "nothing" ].

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	primitives do: [ :primitive | | cases |
		cases := self casesForPrimitive: primitive.
		cases do: [ :case | matrix addCase: { (#case -> case) } ]
	] displayingProgress: [ :p | p value asString ].

	^ matrix
]

{ #category : 'tests' }
RAConcolicRunner >> run: cases with: test [

	| res |
	res := OrderedCollection new.
	cases do: [ :case |
		| theTestToRun |
		theTestToRun := self newTestForCase: case fromPrototype: test.
		('Running ', case asString) traceCr.
		[ case runOn: theTestToRun ]
			on: Error, TestFailure
			do: [ :e | res add: e signalerContext shortDebugStack "ignore the exception and continue" ].
		"Cleanup the test if required"
		case tearDown.
		case solution ].
	^ res
]

{ #category : 'tests' }
RAConcolicRunner >> shouldCache [

	^ shouldCache ifNil: [ true ]
]

{ #category : 'tests' }
RAConcolicRunner >> shouldCache: aBoolean [

	shouldCache := aBoolean
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> solutionsForBytecode: bytecode from: vmBuildingBlock [

	^ RAPathExplorer new
		  failOnError: false;
		  explore: (RABytecodeConcolicCase new
				   vm: self interpreter;
				   bytecode: bytecode;
				   yourself)
		  vmBuildingBlock: vmBuildingBlock
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> solutionsForPrimitive: primitive from: vmBuildingBlock [

	^ RAPathExplorer new failOnError: false;
		explore: (RAPrimitiveConcolicCase new selector: primitive; yourself)
			vmBuildingBlock: vmBuildingBlock.
]

{ #category : 'accessing' }
RAConcolicRunner >> suite [

	"Suite of tests used to set up a new interpreter"
	^ VMJittedGeneralPrimitiveTest buildSuite tests
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> supportedArchitectures [

	^ { 
			{ (#ISA -> #IA32) . (#wordSize -> 4) } .
			"{ #ISA -> #'X64'. #wordSize -> 8}."
			{ (#ISA -> #ARMv5) . (#wordSize -> 4) }
		}.
			"{ #ISA -> #'aarch64'. #wordSize -> 8}."
]
