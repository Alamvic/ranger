Class {
	#name : #RASubstractionConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #microzinc }
RASubstractionConstraint >> mzConstraintOnInterpreter: interpreter [ 
	
	| leftOperand rightOperand leftValue rightValue |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	leftValue := leftOperand.
	rightValue := rightOperand.
	^ leftValue - rightValue
]
