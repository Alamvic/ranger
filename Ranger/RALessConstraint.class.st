Class {
	#name : #RALessConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RALessConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	"In Cassowary we can only express <="
	aSolver addConstraint: (leftOperand cnLEQ: rightOperand)
]

{ #category : #transformations }
RALessConstraint >> invert [

	^ RAGreaterOrEqualsConstraint operands: self operands reversed
]
