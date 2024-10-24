Class {
	#name : 'RASyntacticIsIntMutator',
	#superclass : 'RASyntacticPathMutator',
	#instVars : [
		'bounds'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutator >> bounds [
	
	^ bounds
]

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutator >> bounds: boundNumbers [

	bounds := boundNumbers
]

{ #category : 'testing' }
RASyntacticIsIntMutator >> isMutableConstraint: aConstraint [

	^ self isIntObjVar: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutator >> mutantVariants: constraint [
		
	| var |
	
	var := constraint operands first.
	
	^ bounds collect: [ :n | 
		| bound |
		bound := RAConstant new value: n.
		"Var > n OR Var <= n"
		RAOrConstraint new operands: {
			RAGreaterConstraint new operands: { var .  bound }. "var > n"
			RALessOrEqualsConstraint new operands: { var .  bound } "var <= n"
		}
	]
]

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutator >> mutations: constraints [
	^ self mutateByEachConstraint: constraints
]
