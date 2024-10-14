Class {
	#name : 'RASyntacticVarGreaterThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) > n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self varIsGreaterThanN: constraint ]
]

{ #category : 'testing' }
RASyntacticVarGreaterThanMutator >> isMutableConstraint: aConstraint [

	^ self varIsGreaterThanN: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> mutation: constraint [

	| var const |
	var := constraint operands first.
	const := constraint operands second.

	"Var(A) >= n+1"
	^ RAGreaterOrEqualsConstraint new operands: { var . RAConstant new value: (const value + 1) }
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> mutations: constraints [

	"If exist a constraint Var(x) > n"
	"By each x, we construct a new set of constraints adding Var(A) >= n+1"
	^ self mutateByEachConstraint: constraints
]
