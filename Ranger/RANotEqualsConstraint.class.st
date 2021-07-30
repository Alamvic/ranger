Class {
	#name : #RANotEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #transformations }
RANotEqualsConstraint >> invert [

	^ RANotEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RANotEqualsConstraint >> mzConstraintOnInterpreter: interpreter [ 

	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand notEquals: rightOperand
]

{ #category : #negating }
RANotEqualsConstraint >> negated [

	^ RAEqualsConstraint operands: self operands
]
