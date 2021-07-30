Class {
	#name : #RAGreaterConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RAGreaterConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	"In Cassowary we can only express >="
	aSolver addConstraint: (leftOperand cnGEQ: rightOperand + 1)
]

{ #category : #converting }
RAGreaterConstraint >> invert [

	^ RALessOrEqualsConstraint operands: self operands reversed
]
