Class {
	#name : 'RASyntacticIsNotIntNotEqualsRandomMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticIsNotIntNotEqualsRandomMutator >> isMutableConstraint: aConstraint [

	^ self isIsNotInt: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticIsNotIntNotEqualsRandomMutator >> mutation: constraint [
		
	"IsNonInt(x) and x != RAND"
	^ RAAndConstraint new operands: {
		constraint .
		RANotEqualsConstraint new operands: { constraint operands first . RAConstant new value: self randomNum }
	}
]

{ #category : 'as yet unclassified' }
RASyntacticIsNotIntNotEqualsRandomMutator >> mutations: constraints [

	"If exist a constraint IsNonInt(x)"
	"By each x, we construct a new set of constraints adding IsNonInt(x) and x != RAND"
	^ self mutateByEachConstraint: constraints
]
