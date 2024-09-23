Class {
	#name : 'MutatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'mutator'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'testing' }
MutatorTest >> add: aConstraint to: otherConstraint [
	
	^ RAAddConstraint operands: { aConstraint . otherConstraint }
]

{ #category : 'testing' }
MutatorTest >> const: number [
	
	^ RAConstant value: number
]

{ #category : 'testing' }
MutatorTest >> isChar: aConstraint [
	
	^ RAIsCharacterObject operands: { aConstraint }
]

{ #category : 'testing' }
MutatorTest >> isGreater: aConstraint than: number [
	
	^ RAGreaterConstraint operands: { aConstraint . self const: number }
]

{ #category : 'testing' }
MutatorTest >> isInt: aConstraint [
	
	^ RAIsIntegerObject operands: { aConstraint }
]

{ #category : 'testing' }
MutatorTest >> isLess: aConstraint than: number [
	
	^ RALessConstraint operands: { aConstraint . self const: number }
]

{ #category : 'accessing' }
MutatorTest >> mutator: aMutator [

	mutator := aMutator.
]
