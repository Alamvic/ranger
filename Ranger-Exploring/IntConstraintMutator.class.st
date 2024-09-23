Class {
	#name : 'IntConstraintMutator',
	#superclass : 'IdleMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
IntConstraintMutator >> mutateConstraints: someConstraints [ 
	
	| intConstraints |
	intConstraints := someConstraints select: [ :constraint | constraint class = RAIsIntegerObject ].

	^ someConstraints copy, (self mutationsByIntConstraints: intConstraints)
]

{ #category : 'as yet unclassified' }
IntConstraintMutator >> mutationsByIntConstraints: intConstraints [
	
	^ intConstraints collect: [ :constraint | self mutateConstraint: constraint ]
]
