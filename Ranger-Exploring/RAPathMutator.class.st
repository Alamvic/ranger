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

	^ syntacticMutators inject: {} into: [ :currentMutations :syntacticMutator |
		currentMutations, (syntacticMutator mutatePath: path)
	]
]

{ #category : 'accessing' }
RAPathMutator >> syntacticMutators [
	
	^ syntacticMutators
]
