Class {
	#name : #RAGreaterConstraint,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAGreaterConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) > (operands second evaluateWith: anObjectBuilder)
]

{ #category : #converting }
RAGreaterConstraint >> invert [

	^ RALessOrEqualsConstraint operands: self operands reversed
]

{ #category : #microzinc }
RAGreaterConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand greaterThan: rightOperand
]

{ #category : #negating }
RAGreaterConstraint >> negated [
	
	^ RALessOrEqualsConstraint operands: self operands
]
