Class {
	#name : 'RAPathMutatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'mutator',
		'intPath',
		'arrayPath',
		'isIntA',
		'isCharA',
		'isIntB',
		'isIntPlus'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'adding' }
RAPathMutatorTest >> add: aConstraint to: otherConstraint [
	
	^ RAAddConstraint operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> const: number [
	
	^ RAConstant value: number
]

{ #category : 'adding' }
RAPathMutatorTest >> isChar: aConstraint [
	
	^ RAIsCharacterObject operands: { aConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> isGreater: aConstraint than: number [
	
	^ RAGreaterConstraint operands: { aConstraint . self const: number }
]

{ #category : 'adding' }
RAPathMutatorTest >> isInt: aConstraint [
	
	^ RAIsIntegerObject operands: { aConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> isLess: aConstraint than: number [
	
	^ RALessConstraint operands: { aConstraint . self const: number }
]

{ #category : 'tests' }
RAPathMutatorTest >> setUp [ 

	| a b c aPlusB |

	super setUp.
	a := self const: 500.
	b := self const: 400.
	c := self const: $c.
	aPlusB := self add: a to: b.
	
	isIntA := self isInt: a. "int(500)"
	isCharA := self isChar: c. "char('c')"
	isIntB := self isInt: b. "int(400)"
	isIntPlus := self isInt: aPlusB. "int(500 + 400)"
	mutator := RAPathMutator new.

	intPath := RAPath new.
	arrayPath := RAPath new.
	
	intPath pathConstraints: { isIntA . isIntB . isIntPlus }. "{ int(500), int(400), int(500 + 400) }"
	
]

{ #category : 'tests' }
RAPathMutatorTest >> testMutatePathNewPathsAreAdded [


]

{ #category : 'tests' }
RAPathMutatorTest >> testMutatePathTheOriginalPathsDoesNotChange [


]

{ #category : 'tests' }
RAPathMutatorTest >> testMutatePathThereIsNoMutationsToApply [

	self assert: (mutator mutatePath: intPath) equals: OrderedCollection new
]
