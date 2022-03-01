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
		newClassInOldSpaceWithSlots: (aClassObject definedFixedFields value ifNil: [ 0 ])
		instSpec: (aClassObject format value ifNil: [0]).

	instances at: aClassObject variableName put: aConcreteClass.
	
	self memory setHashBitsOf: aConcreteClass to: classIndex.
	
	"Check this does not fail... 0 indicates success"
	self assert: (self memory enterIntoClassTable: aConcreteClass) = 0.
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
			                       ifAbsent: [ 
					RAObject new
						initializeWithVariableName: 'temp';
				 		classObject: RAClassObject new; yourself ].
		objectToInstantiate ifNotNil: [ 
			interpreter objectMemory
				storePointer: index + offset
				ofObject: anOop
				withValue: (self instantiate: objectToInstantiate) ] ]
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiate: aRAObject [

	^ aRAObject evaluateWith: self
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiateNonImmediateObject: aRAObject [

	| classIndex newConcreteObject specialID |
	self assert: aRAObject specialObjectIndex value ~= 0.

	specialID := aRAObject specialObject value ifNil: [ 0 ].
	specialID = 1 ifTrue: [ ^ interpreter objectMemory nilObject ].
	specialID = 2 ifTrue: [ ^ interpreter objectMemory trueObject ].
	specialID = 3 ifTrue: [ ^ interpreter objectMemory falseObject ].

	aRAObject specialSelectorIndex value ifNotNil: [ :index |
		^ interpreter specialSelector: index
	].

	"Format 0 should always have 0 slots"
	((aRAObject format value ifNil: [ 0 ]) = 0 and: [ (aRAObject numSlots value ifNil: [ 0 ]) > 0 ])
		ifTrue: [ 
			"Make it a normal pointer object with instance variables"
			aRAObject classObject format value: 1 ].

	1 haltIf: [ (aRAObject classObject definedFixedFields value ifNil:[0]) > 0 ].
	classIndex := self allocateClassObject: aRAObject classObject.
	newConcreteObject := self
		allocateNewSpaceSlots: (self numberOfSlotsOf: aRAObject)
		format: (aRAObject format value ifNil: [ 
			self defaultFormatForClassIndex: classIndex ])
		classIndex: classIndex.
	instances at: aRAObject variableName put: newConcreteObject.
	
	self
		initializeConcreteObject: newConcreteObject
		withConstraints: aRAObject.

	^ newConcreteObject
]

{ #category : #'value-setup' }
RAObjectBuilder >> instantiateObject: aRAObject [

	| typeTag |
	instances
		at: aRAObject variableName
		ifPresent: [ :instance | ^ instance ]. "Otherwise, check if we already instantiated this object"

	"If not, instantiate it and cache it"
	typeTag := aRAObject typeTag value ifNil: [ 0 ].
	typeTag = 0 ifTrue: [ 
		^ self instantiateNonImmediateObject: aRAObject ].
	typeTag = 1 ifTrue: [ 
		| concreteInteger |
		concreteInteger := interpreter objectMemory integerObjectOf:
			                   ((aRAObject integerValue 
				                     mzConstraintOnInterpreter: interpreter)
				                    evaluate ifNil: [ 0 ]).
		^ concreteInteger ].
	typeTag = 2 ifTrue: [ 
		| concreteCharacter |
		concreteCharacter := interpreter objectMemory characterObjectOf:
			                     (aRAObject integerValue value ifNil: [ 0 ]).
		^ concreteCharacter ].
	self halt
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

	| basicNumberOfSlots fixedNumberOfSlots |
	fixedNumberOfSlots := aRAObject classObject definedFixedFields value ifNil: [ 0 ].
	basicNumberOfSlots := aRAObject numSlots value ifNil: [ 0 ].
	1 haltIf: [ fixedNumberOfSlots > 0  and: [ basicNumberOfSlots > 0 ] ].
	basicNumberOfSlots := basicNumberOfSlots max: fixedNumberOfSlots.
	^ (self isCompiledMethod: aRAObject)
		ifTrue: [ basicNumberOfSlots + 1 "Add an extra slot for the heder" ]
		ifFalse: [ basicNumberOfSlots ]
]

{ #category : #accessing }
RAObjectBuilder >> objectById: aString [ 
	
	^ instances at: aString
]

{ #category : #accessing }
RAObjectBuilder >> objectMemory [
	
	^ interpreter objectMemory
]
