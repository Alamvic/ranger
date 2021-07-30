Class {
	#name : #RAGreaterOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #transformations }
RAGreaterOrEqualsConstraint >> invert [

	^ (RALessConstraint operands: self operands reversed)
			origin: origin;
			yourself
]

{ #category : #microzinc }
RAGreaterOrEqualsConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand integerValue greaterOrEquals: rightOperand integerValue
]

{ #category : #negating }
RAGreaterOrEqualsConstraint >> negated [

	^ (RALessConstraint operands: self operands)
			origin: origin;
			yourself
]
