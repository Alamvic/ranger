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
	| constraints varA literal |
	
	varA := self var: 'A'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreater: varA than: literal
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreaterOrEquals: varA than: (self const: 43) }
	}
]

{ #category : 'tests' }
RASyntacticVarGreaterThanMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	
	constraints := {
		self const: 42.
		self isInt: (self const: 'x').
		self isGreater: varA than: (self const: 42).
		self isGreater: varB than: (self const: 1).
		self isGreater: varA than: varB 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreaterOrEquals: varA than: (self const: 43) }.
		constraints, { self isGreaterOrEquals: varB than: (self const: 2) }
	}
]
