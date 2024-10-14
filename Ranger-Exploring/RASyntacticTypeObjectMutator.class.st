Class {
	#name : 'RASyntacticTypeObjectMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticTypeObjectMutator >> isMutableConstraint: aConstraint [

	^ self isIsConstraint: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticTypeObjectMutator >> mutation: constraint [

	| value |
	value := constraint operands first.
	
	"isX(A) -> Add isNotY AND, for all Y != X"
	^ self allISConstraints inject: constraint into: [ :andOp :currentClass |
		({ currentClass . currentClass inverseClass } includes: constraint class) ifFalse: [
			RAAndConstraint new operands: {
				(currentClass inverseClass new operands: { value }; yourself).
				andOp
			}
		] ifTrue: [ andOp ]
	]


]

{ #category : 'as yet unclassified' }
RASyntacticTypeObjectMutator >> mutations: constraints [

	"If exist a constraint isX(A)"
	"By each X, we construct a new set of constraints adding AND isNotY, for all Y != X"
	^ self mutateByEachConstraint: constraints
]
