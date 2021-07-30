Class {
	#name : #RAIsIntegerObject,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAIsIntegerObject >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

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

	aSolver addConstraint: (operand typeTag cnEqual: 1)
]

{ #category : #negating }
RAIsIntegerObject >> negated [
	
	^ RAIsNonTaggedObject operands: self operands
]

{ #category : #adding }
RAIsIntegerObject >> prettyIdentifier [

	^ 'isIntegerObject'
]

{ #category : #adding }
RAIsIntegerObject >> prettyString [

	^ 'isIntegerObject(', operands first prettyString, ')'
]
