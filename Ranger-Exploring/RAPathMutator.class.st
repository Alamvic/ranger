Class {
	#name : 'RAPathMutator',
	#superclass : 'Object',
	#instVars : [
		'syntacticMutators'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RAPathMutator class >> lastestPathMutator [
	
	^self new
		"This returns the most updated mutators"
		addSyntacticMutator: RASyntacticVarGreaterThanMutator new;
		addSyntacticMutator: RASyntacticCommutativeOperationMutator new;
		addSyntacticMutator: RASyntacticVarLessThanMutator new;
		addSyntacticMutator: RASyntacticNLessThanVarMutator new;
		addSyntacticMutator: RASyntacticVarGreaterOrEqualsThanVarMutator new; 
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

	^ (syntacticMutators inject: OrderedCollection new writeStream into: [ :stream :syntacticMutator |
		stream nextPutAll: (syntacticMutator mutatePath: path); yourself
	]) contents
]

{ #category : 'accessing' }
RAPathMutator >> syntacticMutators [
	
	^ syntacticMutators
]
