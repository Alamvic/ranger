Class {
	#name : 'RAEqualsConstraint',
	#superclass : 'RAPathConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RAEqualsConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) = (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'converting' }
RAEqualsConstraint >> invert [

	^ RAEqualsConstraint operands: self operands reversed
]

{ #category : 'as yet unclassified' }
RAEqualsConstraint >> mutate: mutator [

	^ mutator mutateEqualsConstraint: self
]

{ #category : 'microzinc' }
RAEqualsConstraint >> mzConstraintOnInterpreter: interpreter [ 

	| leftOperand rightOperand |
	
	self sanitizeOperands. "TODO: REVIEW THIS"

	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand equals: rightOperand
]

{ #category : 'converting' }
RAEqualsConstraint >> negated [

	^ RANotEqualsConstraint operands: self operands
]

{ #category : 'accessing' }
RAEqualsConstraint >> operator [

	^ '='
]
