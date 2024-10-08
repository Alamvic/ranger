Class {
	#name : 'RASyntacticVarLessThanMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'running' }
RASyntacticVarLessThanMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticVarLessThanMutator new
]

{ #category : 'tests' }
RASyntacticVarLessThanMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints varA |
	
	varA := self var: 'A'.
	constraints := { self isGreater: varA than: 42 . self isInt: (self const: 'x') . varA }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticVarLessThanMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA |
	
	varA := self var: 'A'.
	constraints := {
		self const: 42.
		self isInt: (self const: 'x').
		self isLess: varA than: 0
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isLessOrEquals: varA than: -1 }
	}
]

{ #category : 'tests' }
RASyntacticVarLessThanMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	constraints := {
		self const: 42.
		self isLess: varA than: varB .
		self isInt: (self const: 'x').
		self isGreater: varA than: 42.
		self isLess: varB than: 1.
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isLessOrEquals: varB than: 0 }.
	}
]
