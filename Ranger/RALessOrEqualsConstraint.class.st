Class {
	#name : #RALessOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RALessOrEqualsConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	aSolver addConstraint: (leftOperand cnLEQ: rightOperand)
]

{ #category : #transformations }
RALessOrEqualsConstraint >> invert [

	^ RAGreaterConstraint operands: self operands reversed
]

{ #category : #negating }
RALessOrEqualsConstraint >> negated [
	
	^ (RAGreaterConstraint operands: self operands)
			origin: origin;
			yourself
]
