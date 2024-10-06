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
		"This returns the most updated mutator"
		addSyntacticMutator: RASyntacticArrayPathMutator new;
	yourself
]

{ #category : 'adding' }
RAPathMutator >> addSyntacticMutator: mutator [
	
	self syntacticMutators add: mutator
]

{ #category : 'initialization' }
RAPathMutator >> initialize [ 

	syntacticMutators := OrderedCollection new.
	syntacticMutators add: RASyntacticVarGreaterThanMutator new.
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
