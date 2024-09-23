Class {
	#name : 'RAConstant',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'instance creation' }
RAConstant class >> value: anInteger [ 
	
	self haltIf: [ anInteger isArray ].
	^ self new
		value: anInteger;
		yourself
]

{ #category : 'comparing' }
RAConstant >> = anotherConstant [

	(anotherConstant isKindOf: self class)
		ifFalse: [ ^ false ].
	^ value = anotherConstant value
]

{ #category : 'evaluating' }
RAConstant >> evaluate [
	
	^ value
]

{ #category : 'evaluating' }
RAConstant >> evaluateWith: anObjectBuilder [
	
	^ self value
]

{ #category : 'testing' }
RAConstant >> isConstant [
	
	^ true
]

{ #category : 'testing' }
RAConstant >> isVariable [
	
	^ false
]

{ #category : 'microzinc' }
RAConstant >> mzConstraintOnInterpreter: interpreter [
	
	^ value asMzValue
]

{ #category : 'negating' }
RAConstant >> negated [
	
	"This only works if this is a boolean constant"
	^ RAConstant value: value not
]

{ #category : 'printing' }
RAConstant >> prettyString [
	
	^ value asString
]

{ #category : 'printing' }
RAConstant >> printMinizinc [
	
	^ value asString
]

{ #category : 'printing' }
RAConstant >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: value.
	aStream nextPut: $).
]

{ #category : 'accessing' }
RAConstant >> value [

	^ value
]

{ #category : 'accessing' }
RAConstant >> value: anObject [

	value := anObject
]

{ #category : 'accessing' }
RAConstant >> variables [
	
	^ #()
]
