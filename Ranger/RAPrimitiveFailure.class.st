Class {
	#name : 'RAPrimitiveFailure',
	#superclass : 'Object',
	#category : 'Ranger-Interpreter',
	#package : 'Ranger',
	#tag : 'Interpreter'
}

{ #category : 'executing' }
RAPrimitiveFailure >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executePrimitiveFailure: self
]

{ #category : 'testing' }
RAPrimitiveFailure >> isFailure [
	
	^ true
]

{ #category : 'testing' }
RAPrimitiveFailure >> isInvalid [
	
	^ false
]

{ #category : 'testing' }
RAPrimitiveFailure >> isInvalidIn: aRAPrimitiveAutoTest [ 
	
	"Not invalid!"
	^ false
]

{ #category : 'testing' }
RAPrimitiveFailure >> isPrimitiveFailure [
	
	^ true
]

{ #category : 'compiling' }
RAPrimitiveFailure >> returnResultInto: aTest [

	aTest compileEndInstructionForPrimitiveFailure: self
]
