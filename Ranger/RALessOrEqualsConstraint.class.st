Class {
	#name : #RALessOrEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RALessOrEqualsConstraint >> evaluateWith: interpreter [
	
	^ (operands first evaluateWith: interpreter) <= (operands second evaluateWith: interpreter)
]

{ #category : #transformations }
RALessOrEqualsConstraint >> invert [

	^ RAGreaterConstraint operands: self operands reversed
]

{ #category : #microzinc }
RALessOrEqualsConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand lessOrEquals: rightOperand
]

{ #category : #negating }
RALessOrEqualsConstraint >> negated [
	
	^ RAGreaterConstraint operands: self operands
]
