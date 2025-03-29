Class {
	#name : 'RASyntacticNLessThanVarMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticNLessThanVarMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticNLessThanVarMutator new
]

{ #category : 'tests' }
RASyntacticNLessThanVarMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints varA literal |
	
	varA := self var: 'A'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isLess: varA than: (self const: 0)
	}.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticNLessThanVarMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA literal |
	
	varA := self var: 'A'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isLess: (self const: 0) than: varA 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreaterOrEquals: varA than: (self const: 1) }
	}
]

{ #category : 'tests' }
RASyntacticNLessThanVarMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB literal |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isGreater: varA than: varB .
		self isInt: (self const: 'x').
		self isLess: literal than: varA.
		self isLess: (self const: 1) than: varB.
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isGreaterOrEquals: varA than: (self const: 43) }.
		constraints, { self isGreaterOrEquals: varB than: (self const: 2) }.
	}
]
