Class {
	#name : #RAIsLargeIntegerValue,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAIsLargeIntegerValue >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.
	aSolver addConstraint: ((operand integerValue greaterThan: interpreter objectMemory maxSmallInteger)
		or: (operand integerValue lowerThan: interpreter objectMemory minSmallInteger)).

	"Do nothing, we already know it's a native integer"
	operand typeTag = 2 ifTrue: [ ^ self ].

	aSolver addConstraint: (operand typeTag equals: 2) "Native integer"
]

{ #category : #negating }
RAIsLargeIntegerValue >> negated [

	^ RAIsSmallIntegerValue operands: self operands
]
