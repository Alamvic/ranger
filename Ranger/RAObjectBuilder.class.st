Class {
	#name : #RAObjectBuilder,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'nextIndex'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #asd }
RAObjectBuilder >> allocateClassObject: aClassObject [ 

	| classIndex aClass |
	(aClassObject isNil
		or: [ aClassObject classIndex value isNil
			or: [ aClassObject classIndex value = 0 ] ])
				ifTrue: [ classIndex := self nextOrdinaryClassIndex ]
				ifFalse: [ classIndex := aClassObject classIndex value ].
	
	aClass := self
		newClassInOldSpaceWithSlots: 0
		instSpec: 0 "format".
	self memory setHashBitsOf: aClass to: classIndex.
	self memory
		storePointer: classIndex
		ofObject: self memory classTableFirstPage
		withValue: aClass.
	^ classIndex
]

{ #category : #'value-setup' }
RAObjectBuilder >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ self memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiate: aRAObject [ 
	
	| typeTag |
	typeTag := aRAObject typeTag value ifNil: [ 0 ].
	typeTag = 0 ifTrue: [ | classIndex |
		self assert: aRAObject specialObjectIndex value ~= 0.
		"Format 0 should always have 0 slots"
		self assert: (aRAObject format value isNil
			or: [ aRAObject format value > 0
				or: [ aRAObject numSlots value isNil
					or: [ aRAObject numSlots value = 0 ] ]]).
	
		classIndex := self allocateClassObject: aRAObject classObject.
		self haltIf: [ classIndex = 0 ].
		^ {self
			allocateNewSpaceSlots: (aRAObject numSlots value ifNil: [ 0 ])
			format: (aRAObject format value ifNil: [ 0 ]) "object with instance variables"
			classIndex: classIndex . self newAbstractObject } ].
	typeTag = 1 ifTrue: [ 
		| concreteInteger abstractInteger |
		concreteInteger := interpreter objectMemory integerObjectOf: (aRAObject integerValue value ifNil: [0]).
		abstractInteger := self newAbstractObject.
		^ { concreteInteger . abstractInteger }  ].
	self halt.
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

{ #category : #abstract }
RAObjectBuilder >> newAbstractObject [

	^ RAObject new
		initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
		classObject: (RAClassObject new
			initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
			yourself);
		yourself
]

{ #category : #building }
RAObjectBuilder >> newClassInOldSpaceWithSlots: numberOfSlots instSpec: format [
	| newClass formatWithSlots |

	newClass := self memory
		allocateSlotsInOldSpace: 3
		format: self memory nonIndexablePointerFormat
		classIndex: self memory arrayClassIndexPun.
	
	self memory
		storePointer: 0 "superclass"
		ofObject: newClass
		withValue: self memory nilObject.
	self memory
		storePointer: 1 "method dictionary"
		ofObject: newClass
		withValue: self memory nilObject.
	
	formatWithSlots := format << 16 + numberOfSlots. 
	self memory
		storePointer: 2 "format"
		ofObject: newClass
		withValue: (self memory integerObjectOf: formatWithSlots).
		
	^ newClass	
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
