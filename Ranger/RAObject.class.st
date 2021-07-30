Class {
	#name : #RAObject,
	#superclass : #Object,
	#instVars : [
		'variableName',
		'typeTag',
		'integerValue'
	],
	#category : #Ranger
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

{ #category : #solving }
RAObject >> addToSolver: aClSimplexSolver withVariables: aCollection interpreter: aCogVMSimulatorLSB [ 
	
	^ self
]

{ #category : #printing }
RAObject >> initialize [

	super initialize.
	typeTag := ClVariable new name: variableName , '-type'.
	integerValue := ClVariable new name: variableName , '-value'
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

{ #category : #accessing }
RAObject >> name [
	
	^ variableName
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
