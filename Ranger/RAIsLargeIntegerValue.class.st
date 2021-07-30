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

	"Use two complement"
	aSolver addConstraint:
		(operand integerValue cnGEQ: (interpreter objectMemory minSmallInteger
			twoComplementOfBitSize: interpreter objectMemory numSmallIntegerBits) + 1). "max smallInteger"

	"Do nothing, we already know it's a native integer"
	operand typeTag = 17 ifTrue: [ ^ self ].

	aSolver addConstraint: (operand typeTag cnGEQ: 17) "Native integer"
]

{ #category : #negating }
RAIsLargeIntegerValue >> negated [

	^ RAIsSmallIntegerValue operands: self operands
]
