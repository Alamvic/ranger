Class {
	#name : 'RATest',
	#superclass : 'VMJittedGeneralPrimitiveTest',
	#category : 'Ranger-Tests',
	#package : 'Ranger',
	#tag : 'Tests'
}

{ #category : 'tests' }
RATest class >> testParameters [

	^ ParametrizedTestMatrix new
		addCase: { #ISA -> #'IA32'. #wordSize -> 4};
		yourself
]

{ #category : 'tests' }
RATest >> explorePrimitive: aPrimitiveName [

	| explorer |
	explorer := RAPathExplorer new.
	explorer failOnError: true.
	explorer mutator: LessIntConstraintMutator new.

	^ explorer
		  explore: (RAPrimitiveConcolicCase new
				   selector: aPrimitiveName;
				   yourself)
		  vmBuildingBlock: [ self newVM ]
]

{ #category : 'accessing' }
RATest >> interpreterClass [

	^ RATestingInterpreter
]

{ #category : 'tests' }
RATest >> newVM [

	^ self setUp; interpreter
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveCheckPairOfIntegers [

	| solutions |
	solutions := self explorePrimitive: #primitiveCheckPairOfIntegers.
	
	"The first two solutions are invalid frame accesses because the primitive reads two stack elements"
	self assert: solutions first exitCondition isInvalid.
	self assert: solutions second exitCondition isInvalid.
	
	"Then the next three solutions should be the pairs of two objects where at least one is not a small integer.
	(smi, not smi), (not smi, smi), (not smi, not smi)"
	3 to: 5 do: [ :i | | solution |
		solution := solutions at: i.
		self assert: solution inputConstraints operandStack size equals: 2.
		self assert: (solution inputConstraints operandStack anySatisfy: [ :object |
			object isAbstractSmallInteger not ]).
		self assert: solution exitCondition isPrimitiveFailure.
	].
	
	"Finally, the only success here is when the two stack elements are smi"
	self assert: solutions last exitCondition isSuccess.
	self assert: solutions last inputConstraints operandStack size equals: 2.
	self assert: (solutions last inputConstraints operandStack allSatisfy: [ :object |
			object isAbstractSmallInteger ]).
	self assert: solutions last outputConstraints operandStackTop isAbstractTrueObject
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveCheckPairOfIntegersWithInlinedPopPushBool [

	| solutions |
	solutions := self explorePrimitive: #primitiveCheckPairOfIntegers2.
	
	"The first two solutions are invalid frame accesses because the primitive reads two stack elements"
	self assert: solutions first exitCondition isInvalid.
	self assert: solutions second exitCondition isInvalid.
	
	"Then the next three solutions should be the pairs of two objects where at least one is not a small integer.
	(smi, not smi), (not smi, smi), (not smi, not smi)"
	3 to: 5 do: [ :i | | solution |
		solution := solutions at: i.
		self assert: solution inputConstraints operandStack size equals: 2.
		self assert: (solution inputConstraints operandStack anySatisfy: [ :object |
			object isAbstractSmallInteger not ]).
		self assert: solution exitCondition isPrimitiveFailure.
	].
	
	"Finally, the only success here is when the two stack elements are smi"
	self assert: solutions last exitCondition isSuccess.
	self assert: solutions last inputConstraints operandStack size equals: 2.
	self assert: (solutions last inputConstraints operandStack allSatisfy: [ :object |
			object isAbstractSmallInteger ]).
	self assert: solutions last outputConstraints operandStackTop isAbstractTrueObject
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveCheckingSmallIntegerFailsOnNonSmallInteger [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningInteger.
	
	validSolution := solutions second.
	
	self assert: validSolution exitCondition isPrimitiveFailure.
	self assert: validSolution inputConstraints operandStackTop isAbstractPointersObject.
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveCheckingSmallIntegerSucceedsOnSmallInteger [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningInteger.
	
	validSolution := solutions third.
	
	self assert: validSolution exitCondition isSuccess.
	self assert: validSolution inputConstraints operandStackTop isAbstractSmallInteger.
	self assert: validSolution outputConstraints operandStackTop isAbstractSmallInteger
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveComputedBoolean [

	| solutions |
	solutions := self explorePrimitive: #primitiveComputedBoolean.
	
	"The first solution is invalid frame access"
	self assert: solutions size equals: 3.
	self assert: solutions first exitCondition isInvalid.
	
	"The second solution is a success, returning false because the input is not a smi"
	self assert: solutions second exitCondition isSuccess.
	self assert: solutions second inputConstraints operandStack size equals: 1.
	self deny: 	 solutions second inputConstraints operandStackTop isAbstractSmallInteger.
	self assert: solutions second outputConstraints operandStackTop isAbstractFalseObject.
	
	"The second solution is a success, returning true because the input is a smi"
	self assert: solutions third exitCondition isSuccess.
	self assert: solutions third inputConstraints operandStack size equals: 1.
	self assert: solutions third inputConstraints operandStackTop isAbstractSmallInteger.
	self assert: solutions third outputConstraints operandStackTop isAbstractTrueObject.
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveComputedBooleanWithInlinedPopPushBool [

	| solutions |
	solutions := self explorePrimitive: #primitiveComputedBoolean2.
	
	"The first solution is invalid frame access"
	self assert: solutions size equals: 2.
	self assert: solutions first exitCondition isInvalid.
	
	"Finally, there is a success where the return value is computed from the receiver"
	self assert: solutions last exitCondition isSuccess.

	self assert: solutions last inputConstraints operandStack size equals: 1.
	self
		assert: solutions last outputConstraints operandStackTop
		equals: (RABooleanObjectOf operands: {
			RAIsIntegerObject operands: {	
				solutions last inputConstraints operandStackTop
			}
		})
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveObjectFixedLength [

	| solutions |
	solutions := self explorePrimitive: #primitiveObjectFixedLength.

	"The first solution is invalid frame access because the primitive reads one stack element"
	self assert: solutions first exitCondition isInvalid.

	"Then the next 6 solutions are successes:
	  - stack top with format < 2 and slots <= 1
	  - stack top with format < 2 and slots > 1
	  - stack top with format > 2, format < 9 and slots <= 1
	  - stack top with format > 2, format < 9 and slots > 1
	  - stack top with format = 2 (array format, cannot have fixed slots)
	  - stack top with format > 9 (byte format, cannot have fixed slots)"
	2 to: 7 do: [ :i | | solution |
		solution := solutions at: i.
		self assert: solution exitCondition isSuccess.
	].

	"Finally, it fails if the stack top is an immediate"
	self assert: solutions last exitCondition isFailure.
	self assert: solutions last inputConstraints stackTop isAbstractImmediate
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveReturningReceiver [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveReturningReceiver.
	
	validSolution := solutions second.
	
	self assert: validSolution outputConstraints operandStackTop equals: validSolution inputConstraints operandStackTop
]

{ #category : 'tests' }
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

{ #category : 'tests' }
RATest >> testExplorePrimitiveWithFrameAccessHasASecondValidSolution [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	validSolution := solutions second.
	self deny: validSolution isInvalid.
	
	self assert: validSolution inputConstraints operandStackSize value > 0
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveWithFrameAccessHasFirstAnInvalidSolution [

	| solutions |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	self assert: solutions first isInvalid
]

{ #category : 'tests' }
RATest >> testExplorePrimitiveWithFrameAccessValidSolutionModifiesOutputStack [

	| solutions validSolution |
	solutions := self explorePrimitive: #primitiveWithFrameAccess.
	
	validSolution := solutions second.
	
	self assert: validSolution outputConstraints operandStackTop equals: (RAConstant value: 1)
]

{ #category : 'tests' }
RATest >> testExploreSinglePathPrimitive [

	| solutions |
	solutions := self explorePrimitive: #primitiveWithSinglePath.
	self assert: solutions size equals: 1.
	self assert: solutions first path isEmpty.
	self assert: solutions first exitCondition isSuccess.
	self assert: solutions first exitCondition result equals: (RAConstant value: 1)
]
