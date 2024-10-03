Class {
	#name : 'RASyntacticVarGreaterThanMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> isMutable: aRAPath [

	"If exist a constraint Var(x) > n"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self varIsGreaterThan: constraint ]
]

{ #category : 'as yet unclassified' }
RASyntacticVarGreaterThanMutator >> mutations: constraints [

	"We only returns a mutation where we add the constraint X "
	"
	^ ()"
]
