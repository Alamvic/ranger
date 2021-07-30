Class {
	#name : #RAIsSmallIntegerValue,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #negating }
RAIsSmallIntegerValue >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.

	"Use two complement"
	aSolver addConstraint:
		(operand integerValue cnLEQ: (interpreter objectMemory minSmallInteger
			twoComplementOfBitSize: interpreter objectMemory numSmallIntegerBits)). "max smallInteger"
	aSolver addConstraint: (operand integerValue cnGEQ: 0). "min smallInteger"

	"Do nothing, we already know it's a small integer"
	operand typeTag = 17 ifTrue: [ ^ self ].
	aSolver addConstraint: (operand typeTag cnEqual: 17)
]

{ #category : #negating }
RAIsSmallIntegerValue >> negated [

	^ RAIsLargeIntegerValue operands: self operands
]
