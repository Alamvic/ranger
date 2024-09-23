Class {
	#name : 'LessIntConstraintMutatorTest',
	#superclass : 'IntConstraintMutatorTest',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'running' }
LessIntConstraintMutatorTest >> setUp [ 
	super setUp.
	self mutator: LessIntConstraintMutator new
]

{ #category : 'tests' }
LessIntConstraintMutatorTest >> testAddLessConstraintWithAnOnlyIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA }. "{ int(a) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(a), a < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 }.

]

{ #category : 'tests' }
LessIntConstraintMutatorTest >> testAddLessConstraintWithTwoIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isIntB }. "{ int(500), int(400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), 500 < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 . self isLess: b than: 1000 }.

]

{ #category : 'tests' }
LessIntConstraintMutatorTest >> testAddLessConstraintsWithAddConstraint [
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
LessIntConstraintMutatorTest >> testAddLessConstraintsWithAddConstraintAndOtherStuff [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isCharA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), char('c'), int(400), int(500 + 400), 500 < 1000, 400 < 1000, 500 + 400 < 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isLess: a than: 1000 . self isLess: b than: 1000 . self isLess: aPlusB than: 1000 }.

]
