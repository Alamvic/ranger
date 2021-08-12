Class {
	#name : #RAConstraintBuilder,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'nextIndex'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #accessing }
RAConstraintBuilder >> interpreter [

	^ interpreter
]

{ #category : #accessing }
RAConstraintBuilder >> interpreter: anObject [

	interpreter := anObject
]

{ #category : #testing }
RAConstraintBuilder >> isCompiledMethod: aRAObject [ 
	
	^ aRAObject classObject format value = interpreter objectMemory firstCompiledMethodFormat
]

{ #category : #abstract }
RAConstraintBuilder >> newAbstractMethod [

	| smallInteger |
	smallInteger := self newAbstractObject.
	smallInteger typeTag value: 0.
	smallInteger classObject format value: 24"interpreter objectMemory firstCompiledMethodFormat".
	^ smallInteger
]

{ #category : #abstract }
RAConstraintBuilder >> newAbstractObject [

	^ RAObject new
		initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
		classObject: (RAClassObject new
			initializeWithVariableName: 't', self nextOrdinaryClassIndex asString;
			yourself);
		yourself
]

{ #category : #abstract }
RAConstraintBuilder >> newAbstractSmallInteger [

	^ self newAbstractSmallIntegerWithValue: 0
]

{ #category : #abstract }
RAConstraintBuilder >> newAbstractSmallIntegerWithValue: aValue [

	| smallInteger |
	smallInteger := self newAbstractObject.
	smallInteger typeTag value: 1.
	smallInteger integerValue value: aValue.
	^ smallInteger
]

{ #category : #accessing }
RAConstraintBuilder >> nextIndex [

	^ nextIndex
]

{ #category : #accessing }
RAConstraintBuilder >> nextIndex: anObject [

	^ nextIndex := anObject
]

{ #category : #'value-setup' }
RAConstraintBuilder >> nextOrdinaryClassIndex [
	
	^ nextIndex
		ifNil: [ nextIndex := 100 ]
		ifNotNil: [ nextIndex := nextIndex + 1 ]
]
