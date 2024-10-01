Class {
	#name : 'RAModuloConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
RAModuloConstraint >> mutate: mutator [

	^ mutator mutateModuloConstraint: self
]

{ #category : 'microzinc' }
RAModuloConstraint >> mzConstraintOnInterpreter: interpreter [ 

	"This should be equivalent to Pharo's \\.
	This is equivalent to the following minizinc:
		abs(abs((y * abs((x div y) - (if((x div y) < 0) then 1 else 0 endif)))) - abs(x))
			* if y < 0 then -1 else 1 endif % sign is the divisor
	"
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand mod: rightOperand
]

{ #category : 'printing' }
RAModuloConstraint >> operator [

	^ '%'
]
