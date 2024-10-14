Class {
	#name : 'RASyntacticVarGreaterThanIntroducingNewVarMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticVarGreaterThanIntroducingNewVarMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticVarGreaterThanIntroducingNewVarMutator new
]

{ #category : 'tests' }
RASyntacticVarGreaterThanIntroducingNewVarMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints |
	constraints := { self const: 42 . self isInt: (self const: 'x') . self var: 'A' }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticVarGreaterThanIntroducingNewVarMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA newVar literal |
	
	varA := self var: 'A'.
	newVar := self var: 'A_B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreater: varA than: literal
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreater: (self add: varA to: newVar ) than: (self add: literal to: newVar ) }
	}
]

{ #category : 'tests' }
RASyntacticVarGreaterThanIntroducingNewVarMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA newVar varB newVarB |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	newVar := self var: 'A_B'.
	newVarB := self var: 'B_B'.
		
	constraints := {
		self const: 42.
		self isInt: (self const: 'x').
		self isGreater: varA than: (self const: 42).
		self isGreater: varB than: (self const: 1).
		self isGreater: varA than: varB 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreater: (self add: varA to: newVar ) than: (self add: (self const: 42) to: newVar ) }.
		constraints, { self isGreater: (self add: varB to: newVarB ) than: (self add: (self const: 1) to: newVarB ) }
	}
]
