Class {
	#name : #RAIsNonTaggedObject,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAIsNonTaggedObject >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.
	^ aSolver addConstraint: (operand typeTag cnEqual: 0)
]

{ #category : #negating }
RAIsNonTaggedObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
