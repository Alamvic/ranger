Class {
	#name : 'RAQuotientConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
RAQuotientConstraint >> mutate: mutator [

	^ mutator mutateQuotientConstraint: self
]

{ #category : 'microzinc' }
RAQuotientConstraint >> mzConstraintOnInterpreter: interpreter [ 
	
	"This should be equivalent to Pharo's //.
	This is equivalent to the following minizinc:
		(-x div y) - if (-9 div 4) < 0 then 1 else 0 endif;
	"
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand div: rightOperand
]

{ #category : 'microzinc' }
RAQuotientConstraint >> operator [

	^ '//'
]
