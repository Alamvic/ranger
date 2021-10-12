Class {
	#name : #RASuccess,
	#superclass : #Object,
	#instVars : [
		'result'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #executing }
RASuccess >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executeUntilReturn
]

{ #category : #testing }
RASuccess >> isFailure [
	
	^ false
]

{ #category : #testing }
RASuccess >> isInvalid [

	^ false
]

{ #category : #testing }
RASuccess >> isInvalidIn: aTest [

	"A success is never invalid"
	^ false
]

{ #category : #testing }
RASuccess >> isSuccess [
	
	^ true
]

{ #category : #accessing }
RASuccess >> result [
	
	^ result
]

{ #category : #accessing }
RASuccess >> result: anAbstractValue [
	
	result := anAbstractValue
]

{ #category : #compiling }
RASuccess >> returnResultInto: aTest [

	aTest compileEndInstructionForSuccess: self
]
