Class {
	#name : #RAIsLargeIntegerValue,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAIsLargeIntegerValue >> mzConstraintOnInterpreter: interpreter [ 
	
	| operand |
	operand := operands first mzConstraintOnInterpreter: interpreter.
	^ (operand typeTag equals: 2)
		and: ((operand integerValue greaterThan: interpreter objectMemory maxSmallInteger)
		or: (operand integerValue lowerThan: interpreter objectMemory minSmallInteger))
]

{ #category : #negating }
RAIsLargeIntegerValue >> negated [

	^ RAIsSmallIntegerValue operands: self operands
]
