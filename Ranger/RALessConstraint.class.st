Class {
	#name : #RALessConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #transformations }
RALessConstraint >> invert [

	^ RAGreaterOrEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RALessConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand integerValue lowerThan: rightOperand integerValue
]

{ #category : #negating }
RALessConstraint >> negated [

	^ (RAGreaterOrEqualsConstraint operands: self operands)
			origin: origin;
			yourself
]
