Class {
	#name : 'RASyntacticVarLessThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) < n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self varIsLessThanN: constraint ]
]

{ #category : 'testing' }
RASyntacticVarLessThanMutator >> isMutableConstraint: aConstraint [

	^ self varIsLessThanN: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> mutation: constraint [

	| var const |
	var := constraint operands first.
	const := constraint operands second.
	constraint operands first class = SmallInteger ifTrue: [ 1 halt. ].
	constraint operands second class = SmallInteger ifTrue: [ 1 halt. ].
	
	"Var(A) <= n+1"
	^ RALessOrEqualsConstraint new operands: { var . RAConstant new value: (const value - 1) }
]

{ #category : 'as yet unclassified' }
RASyntacticVarLessThanMutator >> mutations: constraints [

	"If exist a constraint Var(x) < n"
	"By each x, we construct a new set of constraints adding Var(A) <= n-1"
	^ self mutateByEachConstraint: constraints
]
