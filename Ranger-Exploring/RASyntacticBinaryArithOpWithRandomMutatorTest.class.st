Class {
	#name : 'RASyntacticBinaryArithOpWithRandomMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticBinaryArithOpWithRandomMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticBinaryArithOpWithRandomMutator new
]

{ #category : 'tests' }
RASyntacticBinaryArithOpWithRandomMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [

	| constraints varA |
	
	varA := self var: 'A'.
	
	constraints := {
		self const: 42.
		self isInt: (self const: 'x').
		self isGreater: varA than: (self const: 42)
	}.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticBinaryArithOpWithRandomMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA varB literal rand |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	rand := self const: 42. "TODO: Stub random values"
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self add: varA to: varB .
		self op: varA and: varB 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self add: (self add: varA to: rand) to: (self add: varB to: rand) }
	}
]
