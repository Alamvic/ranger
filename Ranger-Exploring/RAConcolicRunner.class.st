Class {
	#name : 'RAConcolicRunner',
	#superclass : 'Object',
	#instVars : [
		'suite',
		'interpreter'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'tests' }
RAConcolicRunner >> casesForAllPrimitives [
	
	^ self casesForPrimitives: (self primitivesFrom: interpreter)
]

{ #category : 'tests' }
RAConcolicRunner >> casesForPrimitive: primitive [

	| generator |
	generator := self primitiveGeneratorFor: primitive.
	
	^ self supportedArchitectures flatCollect: [ :arch |
		  | primitiveSolutions theSetUpTest interpreter |
		  theSetUpTest := suite detect: [ :e |
			                  e parametersToUse do: [ :aParameter |
				                  aParameter applyTo: e ].
			                  e wordSize = arch second value
			                  ].
		  interpreter := theSetUpTest
			                 setUp;
			                 interpreter.
		  primitiveSolutions := self solutionsFor: primitive from: [
			                        theSetUpTest
				                        setUp;
				                        interpreter
			                        ].

		  primitiveSolutions collect: [ :solution |
			  | case |
			  case := RAConcolicCase new.
			  case isa: arch first.
			  case wordsize: arch second.
			  case primitive: primitive.
			  case generator: generator.
			  case solution: solution
			  ]
		  ]
]

{ #category : 'tests' }
RAConcolicRunner >> casesForPrimitives: primitives [
	
	^ primitives flatCollect: [ :primitive | self casesForPrimitive: primitive ]
]

{ #category : 'accessing' }
RAConcolicRunner >> compilerClass [

	^ interpreter cogit class
]

{ #category : 'tests' }
RAConcolicRunner >> initialize [

	super initialize.
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.
	interpreter := suite anyOne
		               setUp;
		               interpreter
]

{ #category : 'accessing' }
RAConcolicRunner >> interpreterClass [
	
	^ interpreter class
]

{ #category : 'tests' }
RAConcolicRunner >> primitiveGeneratorFor: primitive [

	| indexInInterpreterPrimitiveTable |
	"The table is on base 1 and should"
	indexInInterpreterPrimitiveTable := (self interpreterClass
		                                     primitiveTable indexOf:
		                                     primitive) - 1.
	^ (self compilerClass primitiveTable at:
		   indexInInterpreterPrimitiveTable) primitiveGenerator
]

{ #category : 'as yet unclassified' }
RAConcolicRunner >> primitivesFrom: interpreter [

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
RAConcolicRunner >> solutionsFor: primitive from: vmBuildingBlock [

	^ RAPathExplorer new failOnError: false;
		exploreAndMutate: (RAPrimitiveConcolicCase new selector: primitive; yourself)
			vmBuildingBlock: vmBuildingBlock.
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

{ #category : 'tests' }
RAConcolicRunner >> testParameters [

	| matrix primitives |
	matrix := ParametrizedTestMatrix new.

	"Find the list of primitives to test"
	primitives := self primitivesFrom: interpreter.

	"force the progress bar"
	(1 to: 1) do: [ :e |  ] displayingProgress: [ :e | "nothing" ].

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	primitives
		do: [ :primitive |
			| cases |
			cases := self casesForPrimitive: primitive.
			cases do: [ :case | matrix addCase: { (#case -> case) } ]
			]
		displayingProgress: [ :p | p value asString ].
	^ matrix
]
