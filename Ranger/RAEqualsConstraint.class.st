Class {
	#name : #RAEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAEqualsConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) = (operands second evaluateWith: anObjectBuilder)
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
