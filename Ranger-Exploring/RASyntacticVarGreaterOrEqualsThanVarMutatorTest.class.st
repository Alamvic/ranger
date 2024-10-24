Class {
	#name : 'RASyntacticVarGreaterOrEqualsThanVarMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticVarGreaterOrEqualsThanVarMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticVarGreaterOrEqualsThanVarMutator new
]

{ #category : 'tests' }
RASyntacticVarGreaterOrEqualsThanVarMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints |
	constraints := { self const: 42 . self isInt: (self const: 'x') . self var: 'A' }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticVarGreaterOrEqualsThanVarMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA literal |
	
	varA := self var: 'A'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreaterOrEquals: varA than: literal
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, {
			self op: (self op: varA eq: literal) or: (self isGreater: varA than: literal)
		}
	}
]

{ #category : 'tests' }
RASyntacticVarGreaterOrEqualsThanVarMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB literal |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreaterOrEquals: varA than: literal.
		self isGreater: varB than: (self const: 1).
		self isGreaterOrEquals: varA than: varB 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, {
			self op: (self op: varA eq: literal) or: (self isGreater: varA than: literal)
		}.
		constraints, {
			self op: (self op: varA eq: varB) or: (self isGreater: varA than: varB)
		}
	}
]
