Class {
	#name : #RAObject,
	#superclass : #Object,
	#instVars : [
		'variableName',
		'typeTag',
		'integerValue',
		'specialObjectIndex',
		'classIndex',
		'slots',
		'format',
		'numSlots'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #'instance creation' }
RAObject class >> named: aName [

	^ self basicNew
		variableName: aName;
		initialize;
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

	^ classIndex
]

{ #category : #accessing }
RAObject >> classIndex: anObject [

	classIndex := anObject
]

{ #category : #accessing }
RAObject >> format [
	
	^ format
]

{ #category : #accessing }
RAObject >> format: aFormat [
	
	format := aFormat
]

{ #category : #printing }
RAObject >> initialize [

	super initialize.

	"0 = 0 sized objects (UndefinedObject True False et al)
	 1 = non-indexable objects with inst vars (Point et al)
	 2 = indexable objects with no inst vars (Array et al)
	 3 = indexable objects with inst vars (MethodContext AdditionalMethodState et al)
	 4 = weak indexable objects with inst vars (WeakArray et al)
	 5 = weak non-indexable objects with inst vars (ephemerons) (Ephemeron)
	 6 unused, reserved for exotic pointer objects?
	 7 Forwarded Object, 1st field is pointer, rest of fields are ignored
	 8 unused, reserved for exotic non-pointer objects?
	 9 64-bit indexable
	 10 - 11 32-bit indexable
	 12 - 15 16-bit indexable
	 16 - 23 byte indexable
	 24 - 31 compiled method"
	format := MzVariable new
		              name: variableName , '_format';
		              type: '0..31';
		              yourself.
	
	numSlots := MzVariable new
		              name: variableName , '_numSlots';
		              type: '0..1000000' "A million slots is more than enough to test...";
		              yourself.
	slots := Dictionary new.

	classIndex := MzVariable new
		              name: variableName , '_classIndex';
		              type: '0..1000000' "A million classes is more than enough to test...";
		              yourself.

	typeTag := MzVariable new
		           name: variableName , '_type';
		           type: '0..1';
		           yourself.

	integerValue := MzVariable new
		                name: variableName , '_value';
		                type: 'int';
		                yourself.

	specialObjectIndex := MzVariable new
		                      name: variableName , '_specialObjectIndex';
		                      type: 'int';
		                      yourself
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
RAObject >> isConstant [
	
	^ false
]

{ #category : #testing }
RAObject >> isVariable [
	
	^ true
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
RAObject >> slotAt: aRAObject [ 
	1halt.
	^ slots
		at: aRAObject integerValue
		ifAbsentPut: [ RAObject named: variableName, '_slot', slots size asString ]
]

{ #category : #accessing }
RAObject >> specialObjectIndex [

	^ specialObjectIndex
]

{ #category : #accessing }
RAObject >> specialObjectIndex: anObject [

	specialObjectIndex := anObject
]

{ #category : #acccessing }
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
