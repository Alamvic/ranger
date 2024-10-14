Class {
	#name : 'RASyntacticPathMutatorTest',
	#superclass : 'TestCase',
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'adding' }
RASyntacticPathMutatorTest >> add: aConstraint to: otherConstraint [
	
	^ RAAddConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> const: number [
	
	^ RAConstant value: number
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isChar: aConstraint [
	
	^ RAIsCharacterObject new operands: { aConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isGreater: aConstraint than: otherConstraint [
	
	^ RAGreaterConstraint new operands: { aConstraint . otherConstraint } 
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isGreaterOrEquals: aConstraint than: otherConstraint [
	
	^ RAGreaterOrEqualsConstraint new operands: { aConstraint . otherConstraint } 
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isInt: aConstraint [
	
	^ RAIsIntegerObject new operands: { aConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isLess: aConstraint than: otherConstraint [
	
	^ RALessConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isLessOrEquals: aConstraint than: otherConstraint [
	
	^ RALessOrEqualsConstraint new operands: { aConstraint . otherConstraint } 
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isNotChar: aConstraint [
	
	^ RAIsNonCharacterObject new operands: { aConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> op: aConstraint add: otherConstraint [
	
	^ RAAddConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> op: aConstraint and: otherConstraint [
	
	^ RAAndConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> op: aConstraint eq: otherConstraint [
	
	^ RAEqualsConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> op: aConstraint or: otherConstraint [
	
	^ RAOrConstraint new operands: { aConstraint . otherConstraint }
]

{ #category : 'private - initialization' }
RASyntacticPathMutatorTest >> pathFrom: constraints [

	^ RAPath new pathConstraints: constraints
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> var: name [
	
	^ MzVariable new name: name; type: '0..1000000'
]
