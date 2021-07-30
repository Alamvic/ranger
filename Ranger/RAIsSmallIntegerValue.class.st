Class {
	#name : #RAIsSmallIntegerValue,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsSmallIntegerValue >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.

	aSolver addConstraint: (operand integerValue lessOrEquals: (interpreter objectMemory maxSmallInteger)).
	aSolver addConstraint: (operand integerValue greaterOrEquals: (interpreter objectMemory minSmallInteger)).

	"Do nothing, we already know it's a small integer"
	operand typeTag = 2 ifTrue: [ ^ self ].
	aSolver addConstraint: (operand typeTag equals: 2)
]

{ #category : #microzinc }
RAIsSmallIntegerValue >> mzConstraintOnInterpreter: interpreter [
	
	| operand |
	operand := operands first mzConstraintOnInterpreter: interpreter.

	^ (operand integerValue greaterOrEquals: (interpreter objectMemory minSmallInteger))
		and: ((operand integerValue lessOrEquals: (interpreter objectMemory maxSmallInteger))
		and: (operand typeTag equals: 2))
]

{ #category : #negating }
RAIsSmallIntegerValue >> negated [

	^ RAIsLargeIntegerValue operands: self operands
]
