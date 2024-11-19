Class {
	#name : 'RAConcolicRunner',
	#superclass : 'Object',
	#instVars : [
		'interpreter',
		'primitives',
		'bytecodes'
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
			  | case |
			  case := RAConcolicBytecodeCase new. "TODO: Implement me"
			  case isa: arch first.
			  case wordsize: arch second.
			  case bytecode: bytecode.
			  case solution: solution ] ]
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
			                        self newInterpreterForArchitecture: arch ].

		  primitiveSolutions collect: [ :solution |
			  | case |
			  case := RAConcolicPrimitiveCase new.
			  case isa: arch first.
			  case wordsize: arch second.
			  case primitive: primitive.
			  case generator: generator.
			  case solution: solution ] ]
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
RAConcolicRunner >> initialize [

	super initialize.
	interpreter := self suite anyOne setUp; interpreter.
	primitives := self class primitivesFrom: interpreter.
	bytecodes := 1 to: 175
]

{ #category : 'tests' }
RAConcolicRunner >> interpreter [

	^ interpreter
]

{ #category : 'accessing' }
RAConcolicRunner >> interpreterClass [
	
	^ self interpreter class
]

{ #category : 'tests' }
RAConcolicRunner >> newInterpreterForArchitecture: arch [

	| theSetUpTest |
	theSetUpTest := self suite detect: [ :e |
		                e parametersToUse do: [ :aParameter |
			                aParameter applyTo: e ].
		                e wordSize = arch second value ].
	^ theSetUpTest
		  setUp;
		  interpreter
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

	^ cases collect: [ :case |
		  test
			  parametersToUse: {
					  (#case -> 1) asTestParameter.
					  case isa asTestParameter.
					  case wordsize asTestParameter };
			  setUp.
		  [ case runOn: test ]
			  on: Error , TestFailure
			  do: [ :e | "ignore the exception and continue" ].
		  "Cleanup the test if required"
		  case tearDown.
		  case solution ]
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> solutionsForBytecode: bytecode from: vmBuildingBlock [

	^ RAPathExplorer new
		  failOnError: false;
		  exploreAndMutate: (RABytecodeConcolicCase new
				   vm: self interpreter;
				   bytecode: bytecode;
				   yourself)
		  vmBuildingBlock: vmBuildingBlock
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> solutionsForPrimitive: primitive from: vmBuildingBlock [

	^ RAPathExplorer new failOnError: false;
		exploreAndMutate: (RAPrimitiveConcolicCase new selector: primitive; yourself)
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
