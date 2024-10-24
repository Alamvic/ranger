Class {
	#name : 'RASyntacticCommutativeOperationMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticCommutativeOperationMutator >> isMutableConstraint: aConstraint [

	^ self isCommutativeOperation: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutator >> mutantVariants: constraint [

	^ {	 constraint class new operands: {  constraint operands second . constraint operands first } }

]

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutator >> mutations: constraints [

	"If exist a constraint Operation c1 OP c2"
	"By each OP, we construct a new set of constraints adding c2 OP c1"
	^ self mutateByEachConstraint: constraints
]
