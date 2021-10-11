Class {
	#name : #RAObject,
	#superclass : #Object,
	#instVars : [
		'variableName',
		'typeTag',
		'integerValue',
		'specialSelectorIndex',
		'specialObjectIndex',
		'slots',
		'numSlots',
		'classObject',
		'long32Slots',
		'hashBits',
		'constraintFactory',
		'isForwarded',
		'specialObject',
		'floatValue'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'instance creation' }
RAObject class >> named: aName [

	^ self basicNew
		initializeWithVariableName: aName;
		yourself
]

{ #category : #testing }
RAObject >> = anotherVariable [

	(anotherVariable isKindOf: self class)
		ifFalse: [ ^ false ].
	^ variableName = anotherVariable variableName
]

{ #category : #accessing }
RAObject >> classIndex [

	^ classObject classIndex
]

{ #category : #accessing }
RAObject >> classObject [

	^ classObject
]

{ #category : #accessing }
RAObject >> classObject: anObject [

	classObject := anObject
]

{ #category : #accessing }
RAObject >> classTag [

	^ self classObject classIndex
]

{ #category : #accessing }
RAObject >> constraintFactory: aRAConstraintFactory [ 
	constraintFactory := aRAConstraintFactory
]

{ #category : #evaluating }
RAObject >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder instantiate: self
]

{ #category : #slots }
RAObject >> fetchLong32: aConcreteAbstractPair [
	
	| long32 |
	long32 := MzVariable new
		name: variableName , '_long32_', aConcreteAbstractPair first asString;
		type: '-100000..100000' "quite a range for 32 bit integers";
		yourself.
	long32Slots at: aConcreteAbstractPair first ifPresent: [ self halt ].
	long32Slots at: aConcreteAbstractPair first put: (RASlot new
		index: aConcreteAbstractPair second;
		value: long32;
		yourself).
	^ long32
]

{ #category : #accessing }
RAObject >> fetchPointer: anIndex [

	"Indexes are 0 based"
	^ slots at: anIndex + 1 ifAbsentPut: [
		constraintFactory newAbstractObject
	]
]

{ #category : #accessing }
RAObject >> floatValue: aValue [

	floatValue := aValue
]

{ #category : #accessing }
RAObject >> format [

	^ classObject format
]

{ #category : #accessing }
RAObject >> hashBits [

	^ hashBits
]

{ #category : #accessing }
RAObject >> hashBits: anObject [

	hashBits := anObject
]

{ #category : #printing }
RAObject >> initializeWithVariableName: aName [

	variableName := aName.
	numSlots := MzVariable new
		              name: variableName , '_numSlots';
		              type: '0..300' "300 slots is enough to hit large objects";
		              yourself.
	slots := OrderedCollection new.
	long32Slots := OrderedCollection new.

	"
	- 0 / nil is no special object
	- 1 is nil
	- 2 is true
	- 3 is false"
	specialObject := MzVariable new
		           name: variableName , '_specialObject';
		           type: '0..3';
		           yourself.

	"
	- 0 is normal object
	- 1 is small integer
	- 2 is character"
	typeTag := MzVariable new
		           name: variableName , '_type';
		           type: '0..2';
		           yourself.

	integerValue := MzVariable new
		                name: variableName , '_value';
		                type: 'int';
		                yourself.

	specialObjectIndex := MzVariable new
		                      name: variableName , '_specialObjectIndex';
		                      type: 'int';
		                      yourself.
	specialSelectorIndex := MzVariable new
		                      name: variableName , '_specialSelectorIndex';
		                      type: 'int';
		                      yourself.

	hashBits := MzVariable new
		              name: variableName , '_hashBits';
		              type: '0..1000000' "A million is more than enough to test...";
		              yourself.
	
	isForwarded := MzVariable new
		              name: variableName , '_isForwarded';
		              type: '0..1' "A boolean";
		              yourself.
		
	floatValue := MzVariable new
		              name: variableName , '_floatValue';
		              type: 'float';
		              yourself.
]

{ #category : #accessing }
RAObject >> integerValue [
	^ integerValue
]

{ #category : #accessing }
RAObject >> integerValue: anObject [

	integerValue := anObject
]

{ #category : #testing }
RAObject >> isAbstractFalseObject [
	
	^ self specialObject value = 3
]

{ #category : #testing }
RAObject >> isAbstractPointersObject [

	"Type tags are
	0- normal objects
	1- small integers
	2- immediate characters"	
		
	"By default, an unknown typetag is by default interpreted as a pointers object"
	^ #(0 nil) includes: self typeTag value
]

{ #category : #testing }
RAObject >> isAbstractSmallInteger [

	"Type tags are
	0- normal objects
	1- small integers
	2- immediate characters"	
	^ self typeTag value = 1
]

{ #category : #testing }
RAObject >> isAbstractTrueObject [
	
	^ self specialObject value = 2
]

{ #category : #testing }
RAObject >> isBooleanObjectOf [
	
	^ false
]

{ #category : #testing }
RAObject >> isConstant [
	
	^ false
]

{ #category : #printing }
RAObject >> isForwarded [

	^ isForwarded
]

{ #category : #printing }
RAObject >> isForwarded: aValue [

	isForwarded := aValue
]

{ #category : #testing }
RAObject >> isIntegerObjectOf [
	
	^ false
]

{ #category : #testing }
RAObject >> isVariable [
	
	^ true
]

{ #category : #accessing }
RAObject >> long32Slots [

	^ long32Slots
]

{ #category : #accessing }
RAObject >> long32Slots: anObject [

	long32Slots := anObject
]

{ #category : #microzinc }
RAObject >> mzConstraintOnInterpreter: interpreter [
	
	^ self
]

{ #category : #accessing }
RAObject >> name [
	
	^ variableName
]

{ #category : #accessing }
RAObject >> numSlots [
	
	^ numSlots
]

{ #category : #accessing }
RAObject >> numSlots: aNumberOfSlots [
	
	^ numSlots := aNumberOfSlots
]

{ #category : #printing }
RAObject >> prettyString [

	^ variableName
]

{ #category : #printing }
RAObject >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: variableName.
	aStream nextPut: $).
]

{ #category : #accessing }
RAObject >> slots [

	^ slots
]

{ #category : #accessing }
RAObject >> slots: anObject [

	slots := anObject
]

{ #category : #printing }
RAObject >> specialObject [

	^ specialObject
]

{ #category : #accessing }
RAObject >> specialObjectIndex [

	^ specialObjectIndex
]

{ #category : #accessing }
RAObject >> specialObjectIndex: anObject [

	specialObjectIndex := anObject
]

{ #category : #accessing }
RAObject >> specialSelectorIndex [

	^ specialSelectorIndex
]

{ #category : #accessing }
RAObject >> specialSelectorIndex: anIndex [

	specialSelectorIndex := anIndex
]

{ #category : #accessing }
RAObject >> typeTag [
	
	^ typeTag 
]

{ #category : #accessing }
RAObject >> typeTag: anObject [

	typeTag := anObject
]

{ #category : #accessing }
RAObject >> variableName [

	^ variableName
]

{ #category : #accessing }
RAObject >> variableName: anObject [

	variableName := anObject
]

{ #category : #accessing }
RAObject >> variables [
	
	^ { typeTag . integerValue }
]
