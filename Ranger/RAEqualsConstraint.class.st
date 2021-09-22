Class {
	#name : #RAEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAEqualsConstraint >> evaluateWith: interpreter [
	
	^ (operands first evaluateWith: interpreter) = (operands second evaluateWith: interpreter)
]

{ #category : #converting }
RAEqualsConstraint >> invert [

	^ RAEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RAEqualsConstraint >> mzConstraintOnInterpreter: interpreter [ 

	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand equals: rightOperand
]

{ #category : #converting }
RAEqualsConstraint >> negated [

	^ RANotEqualsConstraint operands: self operands
]
