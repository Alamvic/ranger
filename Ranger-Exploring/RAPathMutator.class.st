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
RAPathMutator >> mutatePath: path [

	^ syntacticMutators inject: OrderedCollection new writeStream into: [ :stream :syntacticMutator |
		stream nextPutAll: (syntacticMutator mutatePath: path); yourself
	] contents
]

{ #category : 'accessing' }
RAPathMutator >> syntacticMutators [
	
	^ syntacticMutators
]
