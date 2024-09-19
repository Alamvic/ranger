Class {
	#name : 'RAInterpreterExitCondition',
	#superclass : 'Object',
	#category : 'Ranger-Interpreter',
	#package : 'Ranger',
	#tag : 'Interpreter'
}

{ #category : 'executing' }
RAInterpreterExitCondition >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executeUntilReturn
]

{ #category : 'testing' }
RAInterpreterExitCondition >> isInvalid [
	
	^ false
]

{ #category : 'testing' }
RAInterpreterExitCondition >> isInvalidIn: aTest [ 
	
	self subclassResponsibility
]

{ #category : 'accessing' }
RAInterpreterExitCondition >> result [
	
	self subclassResponsibility
]
