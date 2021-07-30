Class {
	#name : #RABitAndConstraint,
	#superclass : #RAValueConstraint,
	#category : #Ranger
}

{ #category : #adding }
RABitAndConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	^ leftOperand bitAnd: rightOperand
]
