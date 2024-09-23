Class {
	#name : 'IntConstraintMutatorTest',
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
IntConstraintMutatorTest >> setUp [
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
]
