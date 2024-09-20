Class {
	#name : 'IntMutatorTest',
	#superclass : 'MutatorTest',
	#instVars : [
		'a',
		'b',
		'aPlusB',
		'c',
		'path',
		'isIntA',
		'isIntB',
		'isIntPlus',
		'isCharA'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'running' }
IntMutatorTest >> setUp [
	super setUp.
	path := RAPath new.
	a := self const: 500.
	b := self const: 400.
	c := self const: $c.
	aPlusB := self add: a to: b.
	
	isIntA := self isInt: a. "int(500)"
	isCharA := self isChar: c. "char('c')"
	isIntB := self isInt: b. "int(400)"
	isIntPlus := self isInt: aPlusB. "int(500 + 400)"
	
	self mutator: IntConstraintMutator new
]

{ #category : 'tests' }
IntMutatorTest >> testAddLessConstraintWithAnOnlyIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA }. "{ int(a) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(a), a < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 }.

]

{ #category : 'tests' }
IntMutatorTest >> testAddLessConstraintWithTwoIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isIntB }. "{ int(500), int(400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), 500 < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 . self isLess: b than: 1000 }.

]

{ #category : 'tests' }
IntMutatorTest >> testAddLessConstraintsWithAddConstraint [
	"Given a RAPath with constraints of the form int(a), int(b), int(...),
		per each int(x), the mutator will add a new constraint (x < 1000)"
		
	| mutatedConstraints |
	path pathConstraints: { isIntA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), int(400), int(500 + 400), 500 < 1000, 400 < 1000, 500 + 400 < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 . self isLess: b than: 1000 . self isLess: aPlusB than: 1000 }.

]

{ #category : 'tests' }
IntMutatorTest >> testAddLessConstraintsWithAddConstraintAndOtherStuff [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isCharA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), char('c'), int(400), int(500 + 400), 500 < 1000, 400 < 1000, 500 + 400 < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 . self isLess: b than: 1000 . self isLess: aPlusB than: 1000 }.

]
