Class {
	#name : #RAPrimitiveFailure,
	#superclass : #Object,
	#category : #'Ranger-Interpreter'
}

{ #category : #executing }
RAPrimitiveFailure >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executePrimitiveFailure: self
]

{ #category : #testing }
RAPrimitiveFailure >> isFailure [
	
	^ true
]

{ #category : #testing }
RAPrimitiveFailure >> isInvalid [
	
	^ false
]

{ #category : #testing }
RAPrimitiveFailure >> isPrimitiveFailure [
	
	^ true
]

{ #category : #compiling }
RAPrimitiveFailure >> returnResultInto: aTest [

	aTest compileEndInstructionForPrimitiveFailure: self
]
