Class {
	#name : 'RASyntacticVarGreaterThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> constraintMutation: constraint [

	| var const |
	var := (self isVar: constraint operands first) ifTrue: [ constraint operands first ]
																 ifFalse: [ constraint operands second ].

	const := (self isInt: constraint operands first) ifTrue: [ constraint operands first ]
																 ifFalse: [ constraint operands second ].
	
	"Var(A) >= n+1"
	^ RAGreaterOrEqualsConstraint new operands: { var . RAConstant new value: (const value + 1) } ; yourself 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) > n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self varIsGreaterThan: constraint ]
]

{ #category : 'testing' }
RASyntacticVarGreaterThanMutator >> isMutableConstraint: aConstraint [

	^ self varIsGreaterThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> mutations: constraints [

	"If exist a constraint Var(x) > n"
	"By each x, we construct a new set of constraints adding Var(A) >= n+1"
	^ self mutateByEachConstraint: constraints
]
