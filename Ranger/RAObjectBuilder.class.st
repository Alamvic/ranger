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

	"If it is float, do not override it"
	classIndex = 34 ifTrue: [ ^ 34 ].
	
	aClass := self
		newClassInOldSpaceWithSlots: 0
		instSpec: (aClassObject format value ifNil: [0]).
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

{ #category : #'default-values' }
RAObjectBuilder >> defaultFormatForClassIndex: anInteger [ 
	
	"If it is the boxed float class, we set first long format by default"
	anInteger = 34 ifTrue: [ 
		^ interpreter objectMemory firstLongFormat ].
	anInteger = 33 ifTrue: [ 
		^ interpreter objectMemory firstByteFormat ].
	anInteger = 32 ifTrue: [ 
		^ interpreter objectMemory firstByteFormat ].
	
	"object with instance variables"
	^ 0
]

{ #category : #'object-building' }
RAObjectBuilder >> initializeConcreteObject: anOop withConstraints: aRAObject [

	aRAObject format value = interpreter objectMemory firstCompiledMethodFormat ifTrue: [ 
		| numberOfLiterals |
		"Instantiate the method with as many literals as numSlots.
		For the moments, put some small integer as literal"
		numberOfLiterals := self numberOfSlotsOf: aRAObject.
		interpreter objectMemory
				storePointer: 0 "The header"
				ofObject: anOop
				withValue: (interpreter objectMemory integerObjectOf: numberOfLiterals - 1).
		1 to: numberOfLiterals do: [ :index | 
			"For now it's just a small integer"
			interpreter objectMemory
				storePointer: index
				ofObject: anOop
				withValue: (interpreter objectMemory integerObjectOf: 0) ] ]
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiate: aRAObject [

	| typeTag |
	typeTag := aRAObject typeTag value ifNil: [ 0 ].
	typeTag = 0 ifTrue: [ ^ self instantiateNonImmediateObject: aRAObject ].
	typeTag = 1 ifTrue: [ 
		| concreteInteger |
		concreteInteger := interpreter objectMemory integerObjectOf:
			                   (aRAObject integerValue value ifNil: [ 0 ]).
		^ concreteInteger ].
	typeTag = 2 ifTrue: [ 
		| concreteCharacter |
		concreteCharacter := interpreter objectMemory characterObjectOf:
			                     (aRAObject integerValue value ifNil: [ 0 ]).
		^ concreteCharacter ].
	self halt
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiateNonImmediateObject: aRAObject [

	| classIndex newConcreteObject |
	self assert: aRAObject specialObjectIndex value ~= 0.

	"Format 0 should always have 0 slots"
	self assert: (aRAObject format value isNil or: [ 
			 aRAObject format value > 0 or: [ 
				 aRAObject numSlots value isNil or: [ 
					 aRAObject numSlots value = 0 ] ] ]).

	classIndex := self allocateClassObject: aRAObject classObject.
	newConcreteObject := self
		allocateNewSpaceSlots: (self numberOfSlotsOf: aRAObject)
		format: (aRAObject format value ifNil: [ 
			self defaultFormatForClassIndex: classIndex ])
		classIndex: classIndex.
	self
		initializeConcreteObject: newConcreteObject
		withConstraints: aRAObject.

	^ newConcreteObject
]

{ #category : #accessing }
RAObjectBuilder >> interpreter [

	^ interpreter
]

{ #category : #accessing }
RAObjectBuilder >> interpreter: anObject [

	interpreter := anObject
]

{ #category : #testing }
RAObjectBuilder >> isCompiledMethod: aRAObject [ 
	
	^ aRAObject classObject format value = interpreter objectMemory firstCompiledMethodFormat
]

{ #category : #'value-setup' }
RAObjectBuilder >> memory [

	^ interpreter objectMemory
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

{ #category : #'value-setup' }
RAObjectBuilder >> numberOfSlotsOf: aRAObject [

	| basicNumberOfSlots |
	basicNumberOfSlots := aRAObject numSlots value ifNil: [ 0 ].
	^ (self isCompiledMethod: aRAObject)
		ifTrue: [ basicNumberOfSlots + 1 "Add an extra slot for the heder" ]
		ifFalse: [ basicNumberOfSlots ]
]
