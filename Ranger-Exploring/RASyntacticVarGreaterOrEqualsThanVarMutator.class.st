Class {
	#name : 'RASyntacticVarGreaterOrEqualsThanVarMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> constraintMutation: constraint [

	| first second |
	first := constraint operands first.
	second := constraint operands second.
	
	"Var(A) = n OR Var(A) > n"
	^ RAOrConstraint new operands: {
		(RAEqualsConstraint new operands: { first . second }; yourself).
		(RAGreaterConstraint new operands: { first . second }; yourself).
	}; yourself 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) >= n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self isGreaterOrEqualThan: constraint ]
]

{ #category : 'testing' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> isMutableConstraint: aConstraint [

	^ self isGreaterOrEqualThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterOrEqualsThanVarMutator >> mutations: constraints [

	"If exist a constraint Var(A) >= n"
	"By each x, we construct a new set of constraints adding Var(A) = n OR Var(A) > n"
	^ self mutateByEachConstraint: constraints
]