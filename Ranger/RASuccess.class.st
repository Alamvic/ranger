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
RASuccess >> isInvalid [

	^ false
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
