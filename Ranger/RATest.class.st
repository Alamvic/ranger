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
RATest >> testExplorePrimitiveCheckingSmallIntegerFailsOnNonSmallInteger [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningInteger.
	
	validSolution := solutions second.
	
	self assert: validSolution exitCondition isPrimitiveFailure.
	self assert: validSolution inputConstraints operandStackTop isAbstractPointersObject.
]

{ #category : #tests }
RATest >> testExplorePrimitiveCheckingSmallIntegerSucceedsOnSmallInteger [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningInteger.
	
	validSolution := solutions third.
	
	self assert: validSolution exitCondition isSuccess.
	self assert: validSolution inputConstraints operandStackTop isAbstractSmallInteger.
	self assert: validSolution outputConstraints operandStackTop isAbstractSmallInteger
]

{ #category : #tests }
RATest >> testExplorePrimitiveReturningReceiver [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningReceiver.
	
	validSolution := solutions second.
	
	self assert: validSolution outputConstraints operandStackTop equals: validSolution inputConstraints operandStackTop
]

{ #category : #tests }
RATest >> testExplorePrimitiveReturningReceiverPlusOne [

	| solutions validSolution outputStackTop inputStackTop |
	solutions := self explorePrimitive: #primitiveReturningReceiverPlusOne.
	
	validSolution := solutions third.
	
	inputStackTop := validSolution inputConstraints operandStackTop.
	self assert: inputStackTop isAbstractSmallInteger.
	
	outputStackTop := validSolution outputConstraints operandStackTop.
	self assert: outputStackTop isAbstractSmallInteger.
	self
		assert: outputStackTop integerValue
		equals: (RAAddConstraint operands: { 
			inputStackTop integerValue.
			RAConstant value: 1 })
]

{ #category : #tests }
RATest >> testExplorePrimitiveWithFrameAccessHasASecondValidSolution [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	validSolution := solutions second.
	self deny: validSolution isInvalid.
	
	self assert: validSolution inputConstraints operandStackSize value > 0
]

{ #category : #tests }
RATest >> testExplorePrimitiveWithFrameAccessHasFirstAnInvalidSolution [

	| solutions |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	self assert: solutions first isInvalid
]

{ #category : #tests }
RATest >> testExplorePrimitiveWithFrameAccessValidSolutionModifiesOutputStack [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	validSolution := solutions second.
	
	self assert: validSolution outputConstraints operandStackTop equals: (RAConstant value: 1)
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
