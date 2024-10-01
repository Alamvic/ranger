Class {
	#name : 'RASubstractionConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
RASubstractionConstraint >> mutate: mutator [

	^ mutator mutateSubstractionConstraint: self
]

{ #category : 'microzinc' }
RASubstractionConstraint >> mzConstraintOnInterpreter: interpreter [ 
	
	| leftOperand rightOperand leftValue rightValue |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	leftValue := leftOperand.
	rightValue := rightOperand.
	^ leftValue - rightValue
]

{ #category : 'printing' }
RASubstractionConstraint >> operator [

	^ '-'
]
