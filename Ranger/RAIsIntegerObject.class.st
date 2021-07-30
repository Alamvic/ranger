Class {
	#name : #RAIsIntegerObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #adding }
RAIsIntegerObject >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.

	aSolver addConstraint: (operand integerValue lessOrEquals: interpreter objectMemory maxSmallInteger).
	aSolver addConstraint: (operand integerValue greaterOrEquals: interpreter objectMemory minSmallInteger).
	aSolver addConstraint: (operand typeTag equals: 1)
]

{ #category : #microzinc }
RAIsIntegerObject >> mzConstraintOnInterpreter: interpreter [

	| operand |
	operand := operands first mzConstraintOnInterpreter: interpreter.

	^ (operand integerValue lessOrEquals: interpreter objectMemory maxSmallInteger)
		and: ((operand integerValue greaterOrEquals: interpreter objectMemory minSmallInteger)
		and: (operand typeTag equals: 1))
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
