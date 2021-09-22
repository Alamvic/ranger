Class {
	#name : #RATest,
	#superclass : #VMJittedGeneralPrimitiveTest,
	#category : #'Ranger-Tests'
}

{ #category : #tests }
RATest class >> testParameters [

	^ ParametrizedTestMatrix new
		addCase: { #ISA -> #'IA32'. #wordSize -> 4};
		yourself
]

{ #category : #tests }
RATest >> explorePrimitive: aPrimitiveName [

	| explorer |
	explorer := RAPathExplorer new.
	explorer failOnError: true.

	^ explorer
		  explore: (RAPrimitiveConcolicCase new
				   selector: aPrimitiveName;
				   yourself)
		  vmBuildingBlock: [ self newVM ]
]

{ #category : #accessing }
RATest >> interpreterClass [

	^ RATestingInterpreter
]

{ #category : #tests }
RATest >> newVM [

	^ self setUp; interpreter
]

{ #category : #tests }
RATest >> testExplorePrimitiveWithFrameAccessHasFirstAnInvalidSolution [

	| solutions |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	self assert: solutions first isInvalid
]

{ #category : #tests }
RATest >> testExplorePrimitiveWithFrameAccessHasSecondAnValidSolution [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	validSolution := solutions second.
	self deny: validSolution isInvalid.
	
	self assert: validSolution inputConstraints operandStackSize value > 0
]

{ #category : #tests }
RATest >> testExploreSinglePathPrimitive [

	| solutions |
	solutions := self explorePrimitive: #primitiveWithSinglePath.
	self assert: solutions size equals: 1.
	self assert: solutions first path isEmpty.
	self assert: solutions first exitCondition isSuccess.
	self assert: solutions first exitCondition result equals: (RAConstant value: 1)
]
