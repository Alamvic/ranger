Class {
	#name : 'IntConstraintMutator',
	#superclass : 'IdleMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
IntConstraintMutator >> mutateConstraints: someConstraints [ 
	
	| intContraints |
	intContraints := someConstraints select: [ :constraint | constraint class = RAIsIntegerObject ].

	^ someConstraints copy, (intContraints collect: [ :constraint | self mutateConstraint: constraint ])
]

{ #category : 'as yet unclassified' }
IntConstraintMutator >> mutateIsIntegerObjectConstraint: aConstraint [

	^ RALessConstraint operands: { aConstraint operands first . RAConstant value: 1000 }
]
