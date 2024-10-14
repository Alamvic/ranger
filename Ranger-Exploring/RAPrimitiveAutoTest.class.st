Class {
	#name : 'RAPrimitiveAutoTest',
	#superclass : 'RAAbstractAutoTest',
	#instVars : [
		'endInstruction',
		'primitiveAddress',
		'compilationResult',
		'case'
	],
	#category : 'Ranger-Exploring-Tests',
	#package : 'Ranger-Exploring',
	#tag : 'Tests'
}

{ #category : 'building suites' }
RAPrimitiveAutoTest class >> exploreCasesForPrimitive: aPrimitive withWordSize: aWordSize [

	"TODO: Delete me"

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
		  exploreAndMutate: (RAPrimitiveConcolicCase new
				   selector: aPrimitive;
				   yourself)
		  vmBuildingBlock: [ 
		  (suite detect: [ :e | 
				   e parametersToUse do: [ :aParameter | aParameter applyTo: e ].
				   e wordSize = aWordSize ])
			  setUp;
			  interpreter ]
]

{ #category : 'building suites' }
RAPrimitiveAutoTest class >> exploreSolutions: primitiveCode fromSetUp: theSetUpTest [

	^ RAPathExplorer new
		  failOnError: true;
		  exploreAndMutate: (RAPrimitiveConcolicCase new
				   selector: primitiveCode;
				   yourself)
		  vmBuildingBlock: [ RATest new newVM"theSetUpTest setUp; interpreter" ]
]

{ #category : 'building suites' }
RAPrimitiveAutoTest class >> solutionsFor: aPrimitiveName [
	
	^ self solutionsFor: aPrimitiveName forArch: 4 "bytes"
]

{ #category : 'building suites' }
RAPrimitiveAutoTest class >> solutionsFor: primitiveCode forArch: arch [

	^ self exploreSolutions: primitiveCode fromSetUp: nil "theSetUpTest"
]

{ #category : 'building suites' }
RAPrimitiveAutoTest class >> testParameters [

	| runner |
	runner := RAConcolicRunner new.
	runner testParameters
]

{ #category : 'accessing' }
RAPrimitiveAutoTest >> case [

	^ case
]

{ #category : 'accessing' }
RAPrimitiveAutoTest >> case: anObject [

	case := anObject
]

{ #category : 'accessing' }
RAPrimitiveAutoTest >> objectBuilder [

	^ objectBuilder
]

{ #category : 'running' }
RAPrimitiveAutoTest >> solution: aSolution [

	solution := aSolution
]

{ #category : 'running' }
RAPrimitiveAutoTest >> testPrimitive [

	case runOn: self
]
