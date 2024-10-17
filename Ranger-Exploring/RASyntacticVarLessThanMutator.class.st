Class {
	#name : 'RASyntacticVarLessThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticVarLessThanMutator >> isMutableConstraint: aConstraint [

	^ self varIsLessThanN: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> mutation: constraint [

	| var const |
	var := constraint operands first.
	const := constraint operands second.
		
	"Var(A) <= n+1"
	^ RALessOrEqualsConstraint new operands: { var . RAConstant new value: (const value - 1) }
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> mutations: constraints [

	"If exist a constraint Var(x) < n"
	"By each x, we construct a new set of constraints adding Var(A) <= n-1"
	^ self mutateByEachConstraint: constraints
]
