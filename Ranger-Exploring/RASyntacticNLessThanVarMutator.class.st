Class {
	#name : 'RASyntacticNLessThanVarMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticNLessThanVarMutator >> isMutable: aRAPath [

	"If exist a constraint n < X"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self isNLessThan: constraint ]
]

{ #category : 'testing' }
RASyntacticNLessThanVarMutator >> isMutableConstraint: aConstraint [

	^ self isNLessThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticNLessThanVarMutator >> mutation: constraint [

	"A >= n+1"
	^ RAGreaterOrEqualsConstraint new operands: {
		constraint operands second . RAConstant new value: (constraint operands first value + 1)
	}
]

{ #category : 'as yet unclassified' }
RASyntacticNLessThanVarMutator >> mutations: constraints [

	"If exist a constraint n < A"
	"By each x, we construct a new set of constraints adding A >= n+1"
	^ self mutateByEachConstraint: constraints
]
