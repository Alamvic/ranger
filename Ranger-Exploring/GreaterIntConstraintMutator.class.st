Class {
	#name : 'GreaterIntConstraintMutator',
	#superclass : 'IntConstraintMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
GreaterIntConstraintMutator >> mutateIsIntegerObjectConstraint: aConstraint [

	^ RAGreaterConstraint operands: { aConstraint operands first . RAConstant value: self value }
]

{ #category : 'evaluating' }
GreaterIntConstraintMutator >> value [

	^ 1000
]
