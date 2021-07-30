Class {
	#name : #RAGreaterOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RAGreaterOrEqualsConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	aSolver addConstraint: (leftOperand cnGEQ: rightOperand)
]

{ #category : #transformations }
RAGreaterOrEqualsConstraint >> invert [

	^ (RALessConstraint operands: self operands reversed)
			origin: origin;
			yourself
]

{ #category : #negating }
RAGreaterOrEqualsConstraint >> negated [

	^ (RALessConstraint operands: self operands)
			origin: origin;
			yourself
]
