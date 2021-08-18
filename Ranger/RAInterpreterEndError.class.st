Class {
	#name : #RAInterpreterEndError,
	#superclass : #Error,
	#category : #'Ranger-Interpreter'
}

{ #category : #executing }
RAInterpreterEndError >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executeUntilSendTrampoline
]

{ #category : #accessing }
RAInterpreterEndError >> result [
	
	self subclassResponsibility
]
