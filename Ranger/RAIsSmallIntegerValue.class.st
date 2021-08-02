Class {
	#name : #RAIsSmallIntegerValue,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAIsSmallIntegerValue >> mzConstraintOnInterpreter: interpreter [
	
	| operand |
	operand := operands first mzConstraintOnInterpreter: interpreter.
1halt.
	^ (operand integerValue greaterOrEquals: (interpreter objectMemory minSmallInteger))
		and: ((operand integerValue lessOrEquals: (interpreter objectMemory maxSmallInteger))
		and: (operand typeTag equals: 2))
]

{ #category : #negating }
RAIsSmallIntegerValue >> negated [

	^ RAIsLargeIntegerValue operands: self operands
]
