Class {
	#name : 'RASyntacticCommutativeOperationMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutator >> constraintMutation: constraint [

	^ constraint class new operands: {  constraint operands second . constraint operands first }; yourself

]

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutator >> isMutable: aRAPath [

	"If exist a constraint constraintA OP constraintB ( where OP is a commutative operation )"

	^ aRAPath pathConstraints anySatisfy: [ :constraint | self isCommutativeOperation: constraint ]
]

{ #category : 'testing' }
RASyntacticCommutativeOperationMutator >> isMutableConstraint: aConstraint [

	^ self isCommutativeOperation: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutator >> mutations: constraints [

	"If exist a constraint Operation c1 OP c2"
	"By each OP, we construct a new set of constraints adding c2 OP c1"
	^ self mutateByEachConstraint: constraints
]
