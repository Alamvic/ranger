Class {
	#name : #RALessConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RALessConstraint >> evaluateWith: interpreter [
	
	^ (operands first evaluateWith: interpreter) < (operands second evaluateWith: interpreter)
]

{ #category : #transformations }
RALessConstraint >> invert [

	^ RAGreaterOrEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RALessConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand lowerThan: rightOperand
]

{ #category : #negating }
RALessConstraint >> negated [

	^ RAGreaterOrEqualsConstraint operands: self operands
]
