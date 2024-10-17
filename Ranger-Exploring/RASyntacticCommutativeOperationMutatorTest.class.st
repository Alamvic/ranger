Class {
	#name : 'RASyntacticCommutativeOperationMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticCommutativeOperationMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticCommutativeOperationMutator new
]

{ #category : 'tests' }
RASyntacticCommutativeOperationMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [

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
RASyntacticCommutativeOperationMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA varB literal |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreater: varA than: literal .
		self op: varA and: varB 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self op: varB and: varA  }
	}
]

{ #category : 'as yet unclassified' }
RASyntacticCommutativeOperationMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [
	| constraints varA varB literal |
	
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	
	constraints := {
		literal.
		self isInt: (self const: 'x').
		self isGreater: varA than: literal.
		self op: varA and: varB.
		self op: varB add: varA 
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self op: varB and: varA }.
		constraints, { self op: varA add: varB }
	}
]
