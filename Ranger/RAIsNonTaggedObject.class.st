Class {
	#name : #RAIsNonTaggedObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAIsNonTaggedObject >> mzConstraintOnInterpreter: interpreter [ 

	^ (operands first mzConstraintOnInterpreter: interpreter) typeTag equals: 0
]

{ #category : #negating }
RAIsNonTaggedObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
