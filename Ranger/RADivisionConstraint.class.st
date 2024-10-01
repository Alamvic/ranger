Class {
	#name : 'RADivisionConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
RADivisionConstraint >> mutate: mutator [

	^ mutator mutateDivisionConstraint: self
]

{ #category : 'microzinc' }
RADivisionConstraint >> mzConstraintOnInterpreter: interpreter [ 

	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand div: rightOperand
]

{ #category : 'printing' }
RADivisionConstraint >> operator [

	^ '/'
]
