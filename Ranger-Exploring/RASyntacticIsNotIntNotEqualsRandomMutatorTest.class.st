Class {
	#name : 'RASyntacticIsNotIntNotEqualsRandomMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticIsNotIntNotEqualsRandomMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticIsNotIntNotEqualsRandomMutator new
]

{ #category : 'tests' }
RASyntacticIsNotIntNotEqualsRandomMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints varA |
	
	varA := self var: 'A'.
	constraints := { self isGreater: varA than: (self const: 42) . self isInt: (self const: 'x') . varA }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticIsNotIntNotEqualsRandomMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA literal isNot notEq |
	
	varA := self var: 'A'.
	literal := self const: 42.
	isNot := self isNotInt: (self const: 'x').
	notEq := self op: (isNot operands first) neq: 42.
	
	constraints := {
		literal.
		isNot.
		self isLess: varA than: (self const: 0)
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self op: isNot and: notEq }
	}
]
