Class {
	#name : #RAVariable,
	#superclass : #Object,
	#instVars : [
		'variableName'
	],
	#category : #Ranger
}

{ #category : #'instance creation' }
RAVariable class >> named: aName [

	^ self new
		variableName: aName;
		yourself
]

{ #category : #testing }
RAVariable >> = anotherVariable [

	(anotherVariable isKindOf: self class)
		ifFalse: [ ^ false ].
	^ variableName = anotherVariable variableName
]

{ #category : #testing }
RAVariable >> isConstant [
	
	^ false
]

{ #category : #testing }
RAVariable >> isVariable [
	
	^ true
]

{ #category : #accessing }
RAVariable >> name [
	
	^ variableName
]

{ #category : #printing }
RAVariable >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: variableName.
	aStream nextPut: $).
]

{ #category : #accessing }
RAVariable >> variableName [

	^ variableName
]

{ #category : #accessing }
RAVariable >> variableName: anObject [

	variableName := anObject
]

{ #category : #accessing }
RAVariable >> variables [
	
	^ { self }
]
