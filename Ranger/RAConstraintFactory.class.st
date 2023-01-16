Class {
	#name : #RAConstraintFactory,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'nextIndex'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAConstraintFactory >> interpreter [

	^ interpreter
]

{ #category : #accessing }
RAConstraintFactory >> interpreter: anObject [

	interpreter := anObject
]

{ #category : #testing }
RAConstraintFactory >> isCompiledMethod: aRAObject [ 
	
	^ aRAObject classObject format value = interpreter objectMemory firstCompiledMethodFormat
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractFalseObject [

	| falseObject |
	falseObject := self newAbstractObject.
	falseObject specialObject value: 3.
	^ falseObject
]

{ #category : #factory }
RAConstraintFactory >> newAbstractFloatWithValueVariable: aRAConstant [ 
	
	| floatObjectConstraint |
	floatObjectConstraint := self newAbstractObject.
	"In 32 bits, floats are boxed floats"
	floatObjectConstraint typeTag value: 0.
	floatObjectConstraint classObject classIndex: 33.
	floatObjectConstraint classObject format: 10.
	floatObjectConstraint floatValue: aRAConstant.
	^ floatObjectConstraint
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractMethod [

	| smallInteger |
	smallInteger := self newAbstractObject.
	smallInteger typeTag value: 0.
	smallInteger classObject format value: 24"interpreter objectMemory firstCompiledMethodFormat".
	^ smallInteger
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractNilObject [

	| nilObject |
	nilObject := self newAbstractObject.
	nilObject specialObject value: 1.
	^ nilObject
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractObject [

	^ RAObject new
		constraintFactory: self;
		initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
		classObject: (RAClassObject new
			constraintFactory: self;
			initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
			yourself);
		yourself
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractSmallInteger [

	^ self newAbstractSmallIntegerWithValue: 0
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractSmallIntegerWithValue: aValue [

	| smallInteger |
	smallInteger := self newAbstractObject.
	smallInteger typeTag value: 1.
	smallInteger integerValue value: aValue.
	^ smallInteger
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractSmallIntegerWithValueVariable: aValueVariable [

	| smallInteger |
	smallInteger := self newAbstractObject.
	smallInteger typeTag value: 1.
	smallInteger integerValue: aValueVariable.
	^ smallInteger
]

{ #category : #abstract }
RAConstraintFactory >> newAbstractTrueObject [

	| trueObject |
	trueObject := self newAbstractObject.
	trueObject specialObject value: 2.
	^ trueObject
]

{ #category : #accessing }
RAConstraintFactory >> nextIndex [

	^ nextIndex
]

{ #category : #accessing }
RAConstraintFactory >> nextIndex: anObject [

	^ nextIndex := anObject
]

{ #category : #'value-setup' }
RAConstraintFactory >> nextOrdinaryClassIndex [
	
	^ nextIndex
		ifNil: [ nextIndex := 100 ]
		ifNotNil: [ nextIndex := nextIndex + 1 ]
]
