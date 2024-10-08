Class {
	#name : 'RASyntacticVarLessThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> constraintMutation: constraint [

	| var const |
	var := constraint operands first.
	const := constraint operands second.
	
	"Var(A) <= n+1"
	^ RALessOrEqualsConstraint new operands: { var . RAConstant new value: (const value - 1) } ; yourself 
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) < n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self varIsLessThan: constraint ]
]

{ #category : 'testing' }
RASyntacticVarLessThanMutator >> isMutableConstraint: aConstraint [

	^ self varIsLessThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> mutations: constraints [

	"If exist a constraint Var(x) < n"
	"By each x, we construct a new set of constraints adding Var(A) <= n-1"
	^ self mutateByEachConstraint: constraints
]
