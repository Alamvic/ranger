Class {
	#name : 'GreaterIntConstraintMutatorTest',
	#superclass : 'IntConstraintMutatorTest',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'running' }
GreaterIntConstraintMutatorTest >> setUp [ 
	super setUp.
	self mutator: GreaterIntConstraintMutator new
]

{ #category : 'tests' }
GreaterIntConstraintMutatorTest >> testAddGreaterConstraintWithAnOnlyIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA }. "{ int(a) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(a), a > 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isGreater: a than: 1000 }.

]

{ #category : 'tests' }
GreaterIntConstraintMutatorTest >> testAddGreaterConstraintWithTwoIsInt [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isIntB }. "{ int(500), int(400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), 500 > 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isGreater: a than: 1000 . self isGreater: b than: 1000 }.

]

{ #category : 'tests' }
GreaterIntConstraintMutatorTest >> testAddGreaterConstraintsWithAddConstraint [
	"Given a RAPath with constraints of the form int(a), int(b), int(...),
		per each int(x), the mutator will add a new constraint (x > 1000)"
		
	| mutatedConstraints |
	path pathConstraints: { isIntA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), int(400), int(500 + 400), 500 > 1000, 400 > 1000, 500 + 400 > 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isGreater: a than: 1000 . self isGreater: b than: 1000 . self isGreater: aPlusB than: 1000 }.

]

{ #category : 'tests' }
GreaterIntConstraintMutatorTest >> testAddGreaterConstraintsWithAddConstraintAndOtherStuff [

	| mutatedConstraints |
	path pathConstraints: { isIntA . isCharA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"

	mutatedConstraints := (mutator mutate: path) pathConstraints.
	
	"it should be: { int(500), char('c'), int(400), int(500 + 400), 500 > 1000, 400 > 1000, 500 + 400 > 1000 }"
	self assert: mutatedConstraints equals: path pathConstraints,
	{ self isGreater: a than: 1000 . self isGreater: b than: 1000 . self isGreater: aPlusB than: 1000 }.

]
