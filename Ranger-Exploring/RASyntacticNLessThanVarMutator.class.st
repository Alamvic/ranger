Class {
	#name : 'RASyntacticNLessThanVarMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticNLessThanVarMutator >> isMutableConstraint: aConstraint [

	^ self isNLessThan: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticNLessThanVarMutator >> mutantVariants: constraint [

	"A >= n+1"
	^ {
		RAGreaterOrEqualsConstraint new operands: {
			constraint operands second . RAConstant new value: (constraint operands first value + 1)
		}
	}
]

{ #category : 'as yet unclassified' }
RASyntacticNLessThanVarMutator >> mutations: constraints [

	"If exist a constraint n < A"
	"By each x, we construct a new set of constraints adding A >= n+1"
	^ self mutateByEachConstraint: constraints
]
