Class {
	#name : 'RANotEqualsConstraint',
	#superclass : 'RAPathConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RANotEqualsConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) ~= (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'transformations' }
RANotEqualsConstraint >> invert [

	^ RANotEqualsConstraint operands: self operands reversed
]

{ #category : 'as yet unclassified' }
RANotEqualsConstraint >> mutate: mutator [

	^ mutator mutateNotEqualsConstraint: self
]

{ #category : 'microzinc' }
RANotEqualsConstraint >> mzConstraintOnInterpreter: interpreter [ 

	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand notEquals: rightOperand
]

{ #category : 'negating' }
RANotEqualsConstraint >> negated [

	^ RAEqualsConstraint operands: self operands
]

{ #category : 'accessing' }
RANotEqualsConstraint >> operator [
	
	^ '≠'
]
