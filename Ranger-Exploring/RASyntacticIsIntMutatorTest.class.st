Class {
	#name : 'RASyntacticIsIntMutatorTest',
	#superclass : 'RASyntacticPathMutatorTest',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'running' }
RASyntacticIsIntMutatorTest >> setUp [
	super setUp.

	mutator := RASyntacticIsIntMutator new
]

{ #category : 'tests' }
RASyntacticIsIntMutatorTest >> testWhenNoConstraintHasTheMatchFormThenDoesNotReturnMutations [

	| constraints varA |
	
	varA := self var: 'A'.
	
	constraints := {
		self const: 42.
		self isInt: (self const: 'x').
	}.

	self assert: (mutator mutations: constraints) equals: {}
]

{ #category : 'tests' }
RASyntacticIsIntMutatorTest >> testWhenThereIsAConstraintThatMatchWithTheCriteriaThenReturnsAMutation [
	| constraints varA bound |
	
	"Setting bound  = 0"
	mutator bounds: { 0 }.
	
	bound := self const: 0.
	varA := self var: 'A'.
	
	constraints := {
		self const: 42.
		self isInt: varA.
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self op: (self isGreater: varA than: bound) or: (self isLessOrEquals: varA than: bound) }
	}

]

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaAndThereIsTwoBoundsThenReturnsAMutationPerEachVariable [

	| constraints varA varB minBound maxBound |
	
	"Setting bounds = -1000, 1000"
	
	mutator bounds: (OrderedCollection withAll: #(-1000 1000)).
	
	minBound := self const: -1000. 
	maxBound := self const: 1000.
	varA := self var: 'A'.
	varB := self var: 'B'.
	
	constraints := {
		self const: 42.
		self isInt: varA.
		self isInt: varB.
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, {
			self op: (self isGreater: varA than: minBound) or: (self isLessOrEquals: varA than: minBound).
			self op: (self isGreater: varA than: maxBound) or: (self isLessOrEquals: varA than: maxBound)
		}.
		constraints, {
			self op: (self isGreater: varB than: minBound) or: (self isLessOrEquals: varB than: minBound).
			self op: (self isGreater: varB than: maxBound) or: (self isLessOrEquals: varB than: maxBound)
		}
	}
]

{ #category : 'as yet unclassified' }
RASyntacticIsIntMutatorTest >> testWhenThereIsMoreThanAConstraintThatMatchWithTheCriteriaThenReturnsAMutationPerEachVariable [

	| constraints varA bound varB |
	
	"Setting bound  = max val"
	mutator bounds: { SmallInteger maxVal }.
	
	bound := self const: SmallInteger maxVal.
	varA := self var: 'A'.
	varB := self var: 'B'.
	
	constraints := {
		self const: 42.
		self isInt: varA.
		self isInt: varB.
	}.

	self assert: (mutator mutations: constraints) equals: {
		constraints, { self op: (self isGreater: varA than: bound) or: (self isLessOrEquals: varA than: bound) }.
		constraints, { self op: (self isGreater: varB than: bound) or: (self isLessOrEquals: varB than: bound) }
	}
]
