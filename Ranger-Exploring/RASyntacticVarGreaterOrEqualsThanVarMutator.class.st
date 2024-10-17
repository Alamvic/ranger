Class {
	#name : 'RASyntacticVarGreaterOrEqualsThanVarMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> isMutableConstraint: aConstraint [

	^ self isGreaterOrEqualThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> mutation: constraint [

	| first second |
	first := constraint operands first.
	second := constraint operands second.

	"Var(A) = n OR Var(A) > n"
	^ RAOrConstraint new operands: {
		(RAEqualsConstraint new operands: { first . second }; yourself).
		(RAGreaterConstraint new operands: { first . second }; yourself).
	}
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> mutations: constraints [

	"If exist a constraint Var(A) >= n"
	"By each x, we construct a new set of constraints adding Var(A) = n OR Var(A) > n"
	^ self mutateByEachConstraint: constraints
]
