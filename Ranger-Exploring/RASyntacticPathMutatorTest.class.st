Class {
	#name : 'RASyntacticPathMutatorTest',
	#superclass : 'TestCase',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'adding' }
RASyntacticPathMutatorTest >> add: aConstraint to: otherConstraint [
	
	^ RAAddConstraint new operands: { aConstraint . otherConstraint }; yourself
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> const: number [
	
	^ RAConstant value: number
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isChar: aConstraint [
	
	^ RAIsCharacterObject new operands: { aConstraint }; yourself
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isGreater: aConstraint than: number [
	
	^ RAGreaterConstraint new operands: { aConstraint . self const: number }; yourself 
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isGreaterOrEquals: aConstraint than: number [
	
	^ RAGreaterOrEqualsConstraint new operands: { aConstraint . self const: number }; yourself 
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isInt: aConstraint [
	
	^ RAIsIntegerObject new operands: { aConstraint }; yourself
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> isLess: aConstraint than: number [
	
	^ RALessConstraint new operands: { aConstraint . self const: number }; yourself
]

{ #category : 'adding' }
RASyntacticPathMutatorTest >> var: name [
	
	^ MzVariable new name: name; yourself
]
