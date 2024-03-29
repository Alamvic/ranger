Class {
	#name : #RAMultiplicationConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAMultiplicationConstraint >> evaluateWith: aRAObjectBuilder [ 

	^ (operands first evaluateWith: aRAObjectBuilder) * (operands second evaluateWith: aRAObjectBuilder)
]

{ #category : #microzinc }
RAMultiplicationConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand * rightOperand
]
