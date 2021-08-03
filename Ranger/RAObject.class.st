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
		'numSlots',
		'classObject'
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
RAObject >> classIndex: anObject [

	classIndex := anObject
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
RAObject >> format [

	^ classObject format
]

{ #category : #printing }
RAObject >> initializeWithVariableName: aName [

	variableName := aName.
	numSlots := MzVariable new
		              name: variableName , '_numSlots';
		              type: '0..1000000' "A million slots is more than enough to test...";
		              yourself.
	slots := Dictionary new.

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
RAObject >> slots [

	^ slots
]

{ #category : #accessing }
RAObject >> slots: anObject [

	slots := anObject
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
