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
	constraints := { self isGreater: varA than: (self const: 42) . self isInt: (self const: 'x') . varA }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticVarLessThanMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA literal |
	
	varA := self var: 'A'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isLess: varA than: (self const: 0)
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isLessOrEquals: varA than: (self const: -1) }
	}
]

{ #category : 'tests' }
RASyntacticVarLessThanMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB literal |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isLess: varA than: varB .
		self isInt: (self const: 'x').
		self isGreater: varA than: literal.
		self isLess: varB than: (self const: 1).
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self isLessOrEquals: varB than: (self const: 0) }.
	}
]
