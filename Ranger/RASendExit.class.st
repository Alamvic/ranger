Class {
	#name : #RASendExit,
	#superclass : #RAInterpreterEndError,
	#instVars : [
		'messageReceiver',
		'messageSelector'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #testing }
RASendExit >> isInvalid [
	
	^ false
]

{ #category : #accessing }
RASendExit >> messageReceiver [

	^ messageReceiver
]

{ #category : #accessing }
RASendExit >> messageReceiver: anObject [

	messageReceiver := anObject
]

{ #category : #accessing }
RASendExit >> messageSelector [
	
	^ messageSelector
]

{ #category : #accessing }
RASendExit >> messageSelector: anObject [

	messageSelector := anObject
]

{ #category : #accessing }
RASendExit >> receiver: anObject [

	messageReceiver := anObject
]

{ #category : #compiling }
RASendExit >> returnResultInto: aTest [ 
	
	"This exit means that the compiler should insert a call to a send trampoline.
	We do nothing at this point. We should just assert the call to the trampoline was ok"
]
