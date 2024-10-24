Class {
	#name : 'RASyntacticTypeObjectMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticTypeObjectMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticTypeObjectMutator new
]

{ #category : 'tests' }
RASyntacticTypeObjectMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [
	| constraints |
	constraints := { self const: 42 . self var: 'A' }.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticTypeObjectMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA literal isInt |
	
	varA := self var: 'A'.
	literal := self const: 42.
	isInt := self isInt: (self const: 'x').
	
	constraints := {
		literal.
		isInt.
		self isGreaterOrEquals: varA than: literal
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, {
			self op: (self isNotChar: (self const: 'x')) and: isInt
		}
	}
]
