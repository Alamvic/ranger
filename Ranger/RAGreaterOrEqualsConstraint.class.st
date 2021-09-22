Class {
	#name : #RAGreaterOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAGreaterOrEqualsConstraint >> evaluateWith: interpreter [
	
	^ (operands first evaluateWith: interpreter) >= (operands second evaluateWith: interpreter)
]

{ #category : #transformations }
RAGreaterOrEqualsConstraint >> invert [

	^ RALessConstraint operands: self operands reversed
]

{ #category : #microzinc }
RAGreaterOrEqualsConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand greaterOrEquals: rightOperand
]

{ #category : #negating }
RAGreaterOrEqualsConstraint >> negated [

	^ RALessConstraint operands: self operands
]
