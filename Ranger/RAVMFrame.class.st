Class {
	#name : #RAVMFrame,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'operandStack',
		'method',
		'arguments',
		'locals',
		'frameConstraints'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #accessing }
RAVMFrame class >> builder: anObjectBuilder [

	^ self new
		objectBuilder: anObjectBuilder;
		yourself
]

{ #category : #accessing }
RAVMFrame class >> firstFrameForBuilder: anObjectBuilder [

	^ (self builder: anObjectBuilder)
		initializeFirstFrame;
		yourself
]

{ #category : #accessing }
RAVMFrame >> argumentAt: anIndex [

	^ {arguments at: anIndex . frameConstraints argumentAt: anIndex }
]

{ #category : #accessing }
RAVMFrame >> arguments [

	^ arguments
]

{ #category : #accessing }
RAVMFrame >> arguments: aCollection [

	arguments := aCollection
]

{ #category : #accessing }
RAVMFrame >> frameConstraints [
	
	^ frameConstraints
]

{ #category : #accessing }
RAVMFrame >> frameConstraints: aRAVMFrameConstraint [ 
	frameConstraints := aRAVMFrameConstraint
]

{ #category : #initialization }
RAVMFrame >> initialize [

	super initialize.
	operandStack := Stack new.
	locals := OrderedCollection new.
	arguments := #()
]

{ #category : #accessing }
RAVMFrame >> localAt: anIndex [
	
	^ { locals at: anIndex . frameConstraints localAt: anIndex }
]

{ #category : #accessing }
RAVMFrame >> locals [

	^ locals
]

{ #category : #accessing }
RAVMFrame >> locals: aCollection [ 
	locals := aCollection
]

{ #category : #method }
RAVMFrame >> method [
	
	^ {method. frameConstraints method}
]

{ #category : #accessing }
RAVMFrame >> method: anObject [

	method := anObject
]

{ #category : #accessing }
RAVMFrame >> numberOfArguments [

	^ {arguments size. frameConstraints numberOfArguments }
]

{ #category : #accessing }
RAVMFrame >> numberOfLocals [
	
	^ {locals size . frameConstraints numberOfLocals}
]

{ #category : #accessing }
RAVMFrame >> operandStack [

	^ operandStack
]

{ #category : #accessing }
RAVMFrame >> operandStack: anObject [

	operandStack := anObject
]

{ #category : #initialization }
RAVMFrame >> operandStackAt: stackIndex [

	^ {
		operandStack at: stackIndex.
		frameConstraints operandStackAt: stackIndex
	}
]

{ #category : #initialization }
RAVMFrame >> operandStackAt: stackIndex put: aValue [

	operandStack
		at: stackIndex
		put: aValue first.
	frameConstraints
		operandStackAt: stackIndex
		put: aValue second
]

{ #category : #accessing }
RAVMFrame >> operandStackSize [
	
	^ {operandStack size . frameConstraints operandStackSize }
]

{ #category : #accessing }
RAVMFrame >> operandStackTop [
	
	^ { operandStack top . frameConstraints operandStackTop }
]

{ #category : #initialization }
RAVMFrame >> pop [

	^ operandStack pop
]

{ #category : #accessing }
RAVMFrame >> postCopy [

	arguments := arguments copy.
	locals := locals copy.
	operandStack := operandStack copy.
	frameConstraints := frameConstraints copy.
]

{ #category : #initialization }
RAVMFrame >> push: aValue [

	self pushConcrete: aValue first.
	frameConstraints push: aValue second.
]

{ #category : #'operand stack' }
RAVMFrame >> pushConcrete: aValue [
	
	operandStack push: aValue
]

{ #category : #accessing }
RAVMFrame >> receiver [

	^ {receiver . frameConstraints receiver}
]

{ #category : #accessing }
RAVMFrame >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
RAVMFrame >> top [
	1halt.
	^ operandStack top
]
