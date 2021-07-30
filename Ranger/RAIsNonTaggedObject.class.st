Class {
	#name : #RAIsNonTaggedObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #adding }
RAIsNonTaggedObject >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| operand |
	operand := operands first
		           addToSolver: aSolver
		           withVariables: variables
		           interpreter: interpreter.
	^ aSolver addConstraint: (operand typeTag equals: 0)
]

{ #category : #microzinc }
RAIsNonTaggedObject >> mzConstraintOnInterpreter: interpreter [ 

	^ (operands first mzConstraintOnInterpreter: interpreter) typeTag equals: 0
]

{ #category : #negating }
RAIsNonTaggedObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
