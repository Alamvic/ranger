Class {
	#name : 'RASyntacticVarGreaterThanMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'running' }
RASyntacticVarGreaterThanMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticVarGreaterThanMutator new
]

{ #category : 'tests' }
RASyntacticVarGreaterThanMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints |
	constraints := { self const: 42 . self isInt: (self const: 'x') . self var: 'A' }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticVarGreaterThanMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints |
	constraints := { self const: 42 . self isInt: (self const: 'x') . self isGreater: (self var: 'A') than: 42 }.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreaterOrEquals: (self var: 'A') than: 43 }
	}
]

{ #category : 'tests' }
RASyntacticVarGreaterThanMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [

"TODO"
]
