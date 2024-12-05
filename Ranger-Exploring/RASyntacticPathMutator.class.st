Class {
	#name : 'RASyntacticPathMutator',
	#superclass : 'Object',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'testing' }
RASyntacticPathMutator >> allISConstraints [

	^ { RAIsCharacterObject . RAIsIntegerObject }
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> constraintMutation: constraint [

	| mutations |
	
	mutations := OrderedCollection new.

	(self isMutableConstraint: constraint) ifTrue: [ mutations addAll: (self mutantVariants: constraint) ].
	
	(constraint respondsTo: #operands) ifFalse: [ ^mutations ].
	
	constraint operands doWithIndex: [ :child :index |
		child ifNotNil: [
			mutations addAll: ((self constraintMutation: child) collect: [ :childMutation | | mutation |
				mutation := constraint copy.
				mutation operands at: index put: childMutation.
				mutation
	 		])
		]
	].
	^ mutations
]

{ #category : 'testing' }
RASyntacticPathMutator >> isCommutativeOperation: aConstraint [

	^ { RAAndConstraint . RAOrConstraint . RAEqualsConstraint . RANotEqualsConstraint . RAAddConstraint . RABitAndConstraint . RABitOrConstraint . RAMultiplicationConstraint } includes: aConstraint class
]

{ #category : 'testing' }
RASyntacticPathMutator >> isGreaterOrEqualThan: aConstraint [
	
	^ aConstraint class = RAGreaterOrEqualsConstraint 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isGreaterThan: aConstraint [
	
	^ aConstraint class = RAGreaterConstraint
]

{ #category : 'testing' }
RASyntacticPathMutator >> isInt: aConstraint [

	^ (aConstraint class = RAConstant) and: aConstraint value class = SmallInteger 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isIntObjVar: aConstraint [

	"Force short circuit"
	aConstraint class = RAIsIntegerObject ifFalse: [ ^false ].

	^ { MzVariable . RAObject } includes: aConstraint operands first class
]

{ #category : 'testing' }
RASyntacticPathMutator >> isIsConstraint: aConstraint [

	^ self allISConstraints includes: aConstraint class 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isIsNotInt: aConstraint [

	^ aConstraint class = RAIsNonIntegerObject 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isLessThan: aConstraint [
	
	^ aConstraint class = RALessConstraint 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> isMutable: aRAPath [

	self subclassResponsibility 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isMutableConstraint: aConstraint [

	self subclassResponsibility 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isNLessThan: aConstraint [
	(self isLessThan: aConstraint) ifFalse: [ ^ false ].
	
	^ self isInt: aConstraint operands first
]

{ #category : 'testing' }
RASyntacticPathMutator >> isSimpleBinaryArithmeticOperation: aConstraint [
	
	^ (aConstraint class = RAAddConstraint) or: aConstraint class = RASubstractionConstraint 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isVar: aConstraint [

	^ aConstraint class = MzVariable 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isVarOpInt: aConstraint [

	| x1 x2 |
	x1 := aConstraint operands first.
	x2 := aConstraint operands second.
	
	^ (self isVar: x1) and: (self isInt: x2)
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutantVariants: constraint [

	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutateByEachConstraint: constraints [ 
	| commonConstraints |
	commonConstraints := constraints copy. "POC"

	^ (constraints inject: OrderedCollection new writeStream into: [ :stream :constraint |
		stream nextPutAll: ((self constraintMutation: constraint) collect: [ :mutation |
			commonConstraints, { mutation }
		]); yourself
	]) contents asArray
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutatePath: aRAPath [
	
	^ ( self mutations: aRAPath pathConstraints ) collect: [ :constraints |
		RAPath new pathConstraints: constraints;
			parent: aRAPath parent;
			inputFrame: aRAPath inputs;
			exitCondition: aRAPath exitCondition;
		yourself
	]
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutations: constraints [
	
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> randomNum [
	
	^ (0 to: 100) atRandom
]

{ #category : 'testing' }
RASyntacticPathMutator >> varIsGreaterOrEqualThanN: aConstraint [
	(self isGreaterOrEqualThan: aConstraint) ifFalse: [ ^ false ].
	
	^ self isVarOpInt: aConstraint
]

{ #category : 'testing' }
RASyntacticPathMutator >> varIsGreaterThanN: aConstraint [
	(self isGreaterThan: aConstraint) ifFalse: [ ^ false ].
	
	^ self isVarOpInt: aConstraint
]

{ #category : 'testing' }
RASyntacticPathMutator >> varIsLessThanN: aConstraint [
	(self isLessThan: aConstraint) ifFalse: [ ^ false ].
	
	^ self isVarOpInt: aConstraint
]
