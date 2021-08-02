Class {
	#name : #RAIsNonTaggedObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAIsNonTaggedObject >> mzConstraintOnInterpreter: interpreter [ 
1halt.
	^ (operands first mzConstraintOnInterpreter: interpreter) typeTag equals: 0
]
