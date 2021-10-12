Class {
	#name : #RAClassObject,
	#superclass : #Object,
	#instVars : [
		'format',
		'name',
		'classIndex',
		'definedFixedFields'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAClassObject >> classIndex [
	^ classIndex
]

{ #category : #accessing }
RAClassObject >> classIndex: anObject [

	classIndex := anObject
]

{ #category : #accessing }
RAClassObject >> definedFixedFields [

	^ definedFixedFields
]

{ #category : #accessing }
RAClassObject >> definedFixedFields: anObject [

	definedFixedFields := anObject
]

{ #category : #evaluating }
RAClassObject >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder objectById: name
]

{ #category : #accessing }
RAClassObject >> format [

	^ format
]

{ #category : #accessing }
RAClassObject >> format: anObject [
1halt.
	format := anObject
]

{ #category : #initialization }
RAClassObject >> initializeWithVariableName: aName [

	name := aName.
	
	definedFixedFields := MzVariable new
		name: name , '_numFixedSlots';
		type: '0..1000000' "A million instance variables is more than enough to test...";
		yourself.
	
	classIndex := MzVariable new
		name: name , '_classIndex';
		type: '0..1000000' "A million classes is more than enough to test...";
		yourself.
		
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
		              name: name , '_format';
		              type: '0..31';
		              yourself.
]

{ #category : #testing }
RAClassObject >> isBooleanObjectOf [
	
	^ false
]

{ #category : #testing }
RAClassObject >> isConstant [
	
	^ false
]

{ #category : #tsting }
RAClassObject >> isIntegerObjectOf [

	^ false
]

{ #category : #accessing }
RAClassObject >> variableName [

	^ name
]

{ #category : #accessing }
RAClassObject >> variableName: anObject [

	name := anObject
]
