Class {
	#name : 'RAAbstractStackFrame',
	#superclass : 'Object',
	#instVars : [
		'method',
		'receiver',
		'operandStack',
		'currentTemporaryFrame',
		'returnValue',
		'hasReturned',
		'block'
	],
	#category : 'Ranger-Interpreter',
	#package : 'Ranger',
	#tag : 'Interpreter'
}

{ #category : 'accessing' }
RAAbstractStackFrame >> block [

	^ block
]

{ #category : 'accessing' }
RAAbstractStackFrame >> block: anObject [

	block := anObject
]

{ #category : 'testing' }
RAAbstractStackFrame >> hasReturned [
	^ hasReturned
]

{ #category : 'accessing' }
RAAbstractStackFrame >> home [
	
	method isBlockNode ifFalse: [ ^ self ].
	^ block home
]

{ #category : 'accessing' }
RAAbstractStackFrame >> initialize [

	super initialize.
	hasReturned := false.
	operandStack := Stack new.
	currentTemporaryFrame := Dictionary new
]

{ #category : 'accessing' }
RAAbstractStackFrame >> method [

	^ method
]

{ #category : 'accessing' }
RAAbstractStackFrame >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
RAAbstractStackFrame >> operandStack [

	^ operandStack
]

{ #category : 'accessing' }
RAAbstractStackFrame >> operandStack: anObject [

	operandStack := anObject
]

{ #category : 'accessing' }
RAAbstractStackFrame >> pop [

	^ operandStack pop
]

{ #category : 'accessing' }
RAAbstractStackFrame >> push: aValue [

self haltIf: [ aValue isArray and: [aValue second isArray] ].
	operandStack push: aValue
]

{ #category : 'accessing' }
RAAbstractStackFrame >> receiver [
	^ receiver
]

{ #category : 'accessing' }
RAAbstractStackFrame >> receiver: aReceiver [ 
	receiver := aReceiver.
	returnValue := receiver
]

{ #category : 'return value' }
RAAbstractStackFrame >> return: aValue [

	returnValue := aValue.
	hasReturned := true.
]

{ #category : 'return value' }
RAAbstractStackFrame >> returnValue [

	^ returnValue
]

{ #category : 'accessing' }
RAAbstractStackFrame >> stackTop [
	
	^ operandStack top
]

{ #category : 'temporaries' }
RAAbstractStackFrame >> temporaryAt: aString [

	^ self temporaryFrame at: aString ifAbsent: [ self home temporaryAt: aString ]
]

{ #category : 'temporaries' }
RAAbstractStackFrame >> temporaryAt: aString put: aValue [

	self temporaryFrame at: aString put: aValue
]

{ #category : 'accessing' }
RAAbstractStackFrame >> temporaryFrame [
	
	^ currentTemporaryFrame
]

{ #category : 'accessing' }
RAAbstractStackFrame >> temporaryFrame: anObject [

	currentTemporaryFrame := anObject
]
