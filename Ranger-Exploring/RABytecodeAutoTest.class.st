Class {
	#name : 'RABytecodeAutoTest',
	#superclass : 'RAAbstractAutoTest',
	#instVars : [
		'bytecode',
		'endInstruction',
		'compilationResult',
		'methodAddress',
		'jitCompilerClass',
		'case'
	],
	#category : 'Ranger-Exploring-Tests',
	#package : 'Ranger-Exploring',
	#tag : 'Tests'
}

{ #category : 'building suites' }
RABytecodeAutoTest class >> exploreSolutions: bytecode fromSetUp: theSetUpTest [

	^ RAPathExplorer new
		  failOnError: false;
		  exploreAndMutate: (RABytecodeConcolicCase new
				   vm: (self interpreterFrom: theSetUpTest);
				   bytecode: bytecode;
				   yourself)
		  vmBuildingBlock: [
			  theSetUpTest
				  setUp;
				  interpreter
			  ]
]

{ #category : 'building suites' }
RABytecodeAutoTest class >> interpreterFrom: theSetUpTest [

	^ theSetUpTest setUp; interpreter
]

{ #category : 'building suites' }
RABytecodeAutoTest class >> solutionsFor: bytecode [
	
	^ self solutionsFor: bytecode forArch: 4 "bytes" 
]

{ #category : 'building suites' }
RABytecodeAutoTest class >> solutionsFor: bytecode forArch: arch [

	| suite theSetUpTest |
	suite := VMJittedGeneralPrimitiveTest buildSuite tests.

	"force the progress bar"
	(1 to: 1) do: [ :e |  ] displayingProgress: [ :e | "nothing" ].

	"Build the entire set of tests:
	 - for each architecture
	  - for each primitive to test
	    - for each explored path
	      => build a test case"
	theSetUpTest := suite detect: [ :e |
		                e parametersToUse do: [ :aParameter |
			                aParameter applyTo: e ].
		                e wordSize = arch value
		                ].

	^ self exploreSolutions: bytecode fromSetUp: theSetUpTest
]

{ #category : 'building suites' }
RABytecodeAutoTest class >> testParameters [
	| runner |
	runner := RAConcolicRunner new.
	runner bytecodesTestParameters
	
]

{ #category : 'accessing' }
RABytecodeAutoTest >> bytecode [

	^ bytecode
]

{ #category : 'accessing' }
RABytecodeAutoTest >> bytecode: anObject [

	bytecode := anObject
]

{ #category : 'accessing' }
RABytecodeAutoTest >> case [

	^ case
]

{ #category : 'accessing' }
RABytecodeAutoTest >> case: anObject [

	case := anObject
]

{ #category : 'executing' }
RABytecodeAutoTest >> executeUntilReturn [

	self runFrom: methodAddress until: callerAddress.
	self
		assert: machineSimulator receiverRegisterValue
		equals: (objectBuilder instantiate: solution result)
]

{ #category : 'accessing' }
RABytecodeAutoTest >> jitCompilerClass [

	^ jitCompilerClass
]

{ #category : 'accessing' }
RABytecodeAutoTest >> jitCompilerClass: aClass [ 
	
	jitCompilerClass := aClass
]

{ #category : 'running' }
RABytecodeAutoTest >> prepareCall [

	machineSimulator hasLinkRegister 
		ifTrue: [ 
			"The caller IP in ARM is in the linkRegister"
			machineSimulator linkRegisterValue: callerAddress ].
	"I need to push the caller IP to make a correct frame"
	self pushAddress:  callerAddress.

]

{ #category : 'accessing' }
RABytecodeAutoTest >> receiverTags [

	^ solution inputConstraints receiver typeTag value ifNil: [ 0 ]
]

{ #category : 'running' }
RABytecodeAutoTest >> testBytecode [

	case runOn: self
]
