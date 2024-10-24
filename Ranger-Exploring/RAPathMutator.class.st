Class {
	#name : 'RAPathMutator',
	#superclass : 'Object',
	#instVars : [
		'syntacticMutators'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'as yet unclassified' }
RAPathMutator class >> lastestPathMutator [
	
	^self new
		"This returns the most updated mutators"
		addSyntacticMutator: (RASyntacticIsIntMutator new bounds: (
			OrderedCollection new
			add: 0; add: SmallInteger maxVal; add: SmallInteger minVal;
			add: SmallInteger maxVal / 2; add: SmallInteger minVal / 2; yourself
		));
		addSyntacticMutator: RASyntacticVarGreaterThanMutator new;
		addSyntacticMutator: RASyntacticCommutativeOperationMutator new;
		addSyntacticMutator: RASyntacticVarLessThanMutator new;
		addSyntacticMutator: RASyntacticNLessThanVarMutator new;"
		
"		addSyntacticMutator: RASyntacticVarGreaterOrEqualsThanVarMutator new;

		addSyntacticMutator: RASyntacticTypeObjectMutator new;
		addSyntacticMutator: RASyntacticVarGreaterThanIntroducingNewVarMutator new;
		
		addSyntacticMutator: RASyntacticIsNotIntNotEqualsRandomMutator new;
		addSyntacticMutator: RASyntacticBinaryArithOpWithRandomMutator new;
	yourself
]

{ #category : 'adding' }
RAPathMutator >> addSyntacticMutator: mutator [
	
	self syntacticMutators add: mutator
]

{ #category : 'initialization' }
RAPathMutator >> initialize [ 

	syntacticMutators := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
RAPathMutator >> mutatePath: path [
	
	path ifNil: [ ^ {} ].

	^ (syntacticMutators inject: OrderedCollection new writeStream into: [ :stream :syntacticMutator |
		stream nextPutAll: (syntacticMutator mutatePath: path); yourself
	]) contents
]

{ #category : 'accessing' }
RAPathMutator >> syntacticMutators [
	
	^ syntacticMutators
]
