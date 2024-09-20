Class {
	#name : 'IdleMutatorTest',
	#superclass : 'MutatorTest',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'tests' }
IdleMutatorTest >> setUp [
	super setUp.
	self mutator: IdleMutator new
]

{ #category : 'tests' }
IdleMutatorTest >> testNoMutation [
	"Given a simple RAPath, it returns exactly the same RAPath"
	| path mutatedPath |
	
	path := RAPath new.
	mutatedPath := mutator mutate: path.

	self assert: (mutatedPath pathConstraints) equals: path pathConstraints.
	self assert: (mutatedPath exitCondition) equals: path exitCondition. 
	self assert: (mutatedPath parent) equals: path parent. 
	self assert: (mutatedPath inputs) equals: path inputs.
]
