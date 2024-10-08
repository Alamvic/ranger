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
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand - rightOperand
]

{ #category : 'printing' }
RASubstractionConstraint >> operator [

	^ '-'
]
