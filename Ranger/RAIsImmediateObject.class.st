Class {
	#name : #RAIsImmediateObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #adding }
RAIsImmediateObject >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	1halt.
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.
	"Use two complement"
	aSolver addConstraint: (operand typeTag cnGEQ: 1).
	aSolver addConstraint: (operand typeTag cnLEQ: 3).


	aSolver addConstraint: (operand typeTag cnEqual: 1)
]

{ #category : #negating }
RAIsImmediateObject >> negated [
	
	^ RAIsNonTaggedObject operands: self operands
]

{ #category : #adding }
RAIsImmediateObject >> prettyIdentifier [

	^ 'isIntegerObject'
]

{ #category : #adding }
RAIsImmediateObject >> prettyString [

	^ 'isIntegerObject(', operands first prettyString, ')'
]
