Class {
	#name : #RALessOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
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

{ #category : #microzinc }
RALessOrEqualsConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand integerValue lessOrEquals: rightOperand integerValue
]

{ #category : #negating }
RALessOrEqualsConstraint >> negated [
	
	^ (RAGreaterConstraint operands: self operands)
			origin: origin;
			yourself
]
