Class {
	#name : 'RASyntacticBinaryArithOpWithRandomMutator',
	#superclass : 'RASyntacticPathMutator',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticBinaryArithOpWithRandomMutator >> isMutableConstraint: aConstraint [

	^ self isSimpleBinaryArithmeticOperation: aConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticBinaryArithOpWithRandomMutator >> mutation: constraint [

	| first second random |
	first := constraint operands first.
	second := constraint operands second.
	random := RAConstant new value: self randomNum.
	
	"X + Z OP Y + Z"
	^ constraint class new operands: {
		RAAddConstraint new operands: { first . random }.
		RAAddConstraint new operands: {  second . random }
	}
]

{ #category : 'as yet unclassified' }
RASyntacticBinaryArithOpWithRandomMutator >> mutations: constraints [

	"If exist a constraint x OP Y with OP => ( +, - )"
	"Given Z = random, we construct a new set of constraints adding X + Z OP Y + Z"
	^ self mutateByEachConstraint: constraints
]
