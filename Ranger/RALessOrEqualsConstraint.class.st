Class {
	#name : #RALessOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

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
