Class {
	#name : #RAObjectBuilder,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'nextIndex'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'value-setup' }
RAObjectBuilder >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ self memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiate: aRAObject [ 
	
	aRAObject typeTag = 0 ifTrue: [ 
		self assert: aRAObject specialObjectIndex ~= 0.
		^ self
			allocateNewSpaceSlots: 0 "It has slots, but we should not access them"
			format: 1 "object with instance variables"
			classIndex: self nextOrdinaryClassIndex ].
	aRAObject typeTag = 1 ifTrue: [ 
		^ interpreter objectMemory integerObjectOf: aRAObject integerValue  ].
	self halt.
]

{ #category : #'value-setup' }
RAObjectBuilder >> integerObjectOfTwoComplement: twoComplement [ 
	
	| pharoInteger |
	pharoInteger := twoComplement integerOfTwoComplementOfBitSize: self memory numSmallIntegerBits.
	^ self memory integerObjectOf: pharoInteger
]

{ #category : #accessing }
RAObjectBuilder >> interpreter [

	^ interpreter
]

{ #category : #accessing }
RAObjectBuilder >> interpreter: anObject [

	interpreter := anObject
]

{ #category : #'value-setup' }
RAObjectBuilder >> memory [

	^ interpreter objectMemory
]

{ #category : #accessing }
RAObjectBuilder >> nextIndex [

	^ nextIndex
]

{ #category : #accessing }
RAObjectBuilder >> nextIndex: anObject [

	^ nextIndex := anObject
]

{ #category : #'value-setup' }
RAObjectBuilder >> nextOrdinaryClassIndex [
	
	^ nextIndex
		ifNil: [ nextIndex := self memory classTablePageSize ]
		ifNotNil: [ nextIndex := nextIndex + 1 ]
]
