Class {
	#name : 'LessIntConstraintMutator',
	#superclass : 'IntConstraintMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
LessIntConstraintMutator >> mutateIsIntegerObjectConstraint: aConstraint [

	^ RALessConstraint operands: { aConstraint operands first . RAConstant value: self value }
]

{ #category : 'evaluating' }
LessIntConstraintMutator >> value [

	^ 1000
]
