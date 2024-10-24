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
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

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

{ #category : 'testing' }
RAPathMutatorTest >> isGreaterOrEquals: aConstraint than: otherConstraint [
	
	^ RAGreaterOrEqualsConstraint new operands: { aConstraint . otherConstraint } 
]

{ #category : 'adding' }
RAPathMutatorTest >> isInt: aConstraint [
	
	^ RAIsIntegerObject operands: { aConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> isLess: aConstraint than: number [
	
	^ RALessConstraint operands: { aConstraint . self const: number }
]

{ #category : 'testing' }
RAPathMutatorTest >> isNotChar: aConstraint [
	
	^ RAIsNonCharacterObject new operands: { aConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> op: aConstraint add: otherConstraint [
	
	^ RAAddConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> op: aConstraint and: otherConstraint [
	
	^ RAAndConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> op: aConstraint eq: otherConstraint [
	
	^ RAEqualsConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> op: aConstraint gr: otherConstraint [
	
	^ RAGreaterConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RAPathMutatorTest >> op: aConstraint or: otherConstraint [
	
	^ RAOrConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'tests' }
RAPathMutatorTest >> setUp [ 

	| a b c aPlusB |

	super setUp.
	a := self const: 500.
	b := self const: 400.
	c := self const: $c.
	aPlusB := self op: a add: b.
	
	isIntA := self isInt: a. "int(500)"
	isCharA := self isChar: c. "char('c')"
	isIntB := self isInt: b. "int(400)"
	isIntPlus := self isInt: aPlusB. "int(500 + 400)"
	mutator := RAPathMutator lastestPathMutator.

	intPath := RAPath new pathConstraints: { isIntA . isIntB . isIntPlus }.
	arrayPath := RAPath new.
	
]

{ #category : 'tests' }
RAPathMutatorTest >> testMutatePathGivenTwoPossibleMutationsShouldReturnAnArrayWithBothMutations [

	| mutations path varA varB literal isInt x |

	x := self const: 'x'.
	varA := self var: 'A'.
	varB := self var: 'B'.
	literal := self const: 42.
	isInt := self isInt: x.
	
	path := RAPath new pathConstraints: {
		literal.
		isInt.
		self isGreaterOrEquals: varA than: literal
	}.
	
	mutations := mutator mutatePath: path.

	self assert: (mutations asArray collect: [ :_path | _path pathConstraints ]) equals: {
		path pathConstraints, {
			self op: (self op: varA eq: literal) or: (self op: varA gr: literal)
		}.
		path pathConstraints, { self op: (self isNotChar: x) and: (self isInt: x) }
	}
]

{ #category : 'tests' }
RAPathMutatorTest >> testMutatePathThereIsNoMutationsToApply [

	| aPath |
	
	aPath := RAPath new pathConstraints: { self const: 500 }.

	self assert: (mutator mutatePath: aPath) equals: OrderedCollection new
]

{ #category : 'adding' }
RAPathMutatorTest >> var: name [
	
	^ MzVariable new name: name; type: '0..1000000'
]
