Class {
	#name : #RAObjectBuilder,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'nextIndex',
		'instances'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #asd }
RAObjectBuilder >> allocateClassObject: aClassObject [ 

	| classIndex aConcreteClass |
	(aClassObject isNil
		or: [ aClassObject classIndex value isNil
			or: [ aClassObject classIndex value = 0 ] ])
				ifTrue: [ classIndex := self nextOrdinaryClassIndex ]
				ifFalse: [ classIndex := aClassObject classIndex value ].

	"If it is float, do not override it"
	classIndex = 34 ifTrue: [ ^ 34 ].
	
	aConcreteClass := self
		newClassInOldSpaceWithSlots: 0
		instSpec: (aClassObject format value ifNil: [0]).
	instances at: aClassObject put: aConcreteClass.
	
	self memory setHashBitsOf: aConcreteClass to: classIndex.
	self memory
		storePointer: classIndex
		ofObject: self memory classTableFirstPage
		withValue: aConcreteClass.
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

{ #category : #accessing }
RAObjectBuilder >> initialize [

	super initialize.
	instances := IdentityDictionary new.
]

{ #category : #'object-building' }
RAObjectBuilder >> initializeConcreteObject: anOop withConstraints: aRAObject [

	| offset |
	offset := 0.
	aRAObject format value = interpreter objectMemory firstCompiledMethodFormat
		ifTrue: [
		"Methods have an extra literal for the header"
		interpreter objectMemory
			storePointer: 0
			ofObject: anOop
			withValue: (interpreter objectMemory
				integerObjectOf: (self numberOfSlotsOf: aRAObject) - 1).
		offset := 1 ].

	0 to: (self numberOfSlotsOf: aRAObject) - 1 do: [ :index | 
		| objectToInstantiate |
		objectToInstantiate := aRAObject slots
			                       at: index + 1
			                       ifAbsent: [ nil ].
		objectToInstantiate ifNotNil: [ 
			interpreter objectMemory
				storePointer: index + offset
				ofObject: anOop
				withValue: (self instantiate: objectToInstantiate) ] ]
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiate: aRAObject [

	| typeTag |
	
	instances at: aRAObject ifPresent: [ :instance | ^ instance ].
	
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
	instances at: aRAObject put: newConcreteObject.
	
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
	basicNumberOfSlots := basicNumberOfSlots max: aRAObject slots size.
	^ (self isCompiledMethod: aRAObject)
		ifTrue: [ basicNumberOfSlots + 1 "Add an extra slot for the heder" ]
		ifFalse: [ basicNumberOfSlots ]
]
