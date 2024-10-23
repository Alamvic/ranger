Class {
	#name : 'RASyntacticVarGreaterThanIntroducingNewVarMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticVarGreaterThanIntroducingNewVarMutator >> isMutableConstraint: aConstraint [

	^ self varIsGreaterThanN: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanIntroducingNewVarMutator >> mutantVariants: constraint [

	| var const newVar |
	var := constraint operands first.
	const := constraint operands second.

	"Var(A) + Var(B) > n + Var(B)"
	newVar := MzVariable new name: (var name) , '_B'; type: '0..1000000'.
	^ { RAGreaterConstraint new operands: {
			RAAddConstraint new operands: { var . newVar }.
			RAAddConstraint new operands: { const . newVar }
		}
	}
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanIntroducingNewVarMutator >> mutations: constraints [

	"If exist a constraint Var(x) > n"
	"By each x, we construct a new set of constraints adding Var(A) + Var(B) > n + Var(B)"
	^ self mutateByEachConstraint: constraints
]
