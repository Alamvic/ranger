Class {
	#name : #RAGreaterConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #converting }
RAGreaterConstraint >> invert [

	^ RALessOrEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RAGreaterConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand integerValue greaterThan: rightOperand integerValue
]

{ #category : #negating }
RAGreaterConstraint >> negated [
	
	^ (RALessOrEqualsConstraint operands: self operands)
			origin: origin;
			yourself
]
