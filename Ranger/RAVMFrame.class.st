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

	^ arguments at: anIndex
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
RAVMFrame >> localAt: aConstraint [
	
	| newObject |
	newObject := RAObject named: 'local_xxx'.
	locals add: { aConstraint. newObject }.
	^ newObject
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
	
	^ method
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

{ #category : #initialization }
RAVMFrame >> operandAt: anIndex [

	^ {
		operandStack at: anIndex.
		frameConstraints operandAt: anIndex
	}
]

{ #category : #accessing }
RAVMFrame >> operandStack [

	^ operandStack
]

{ #category : #accessing }
RAVMFrame >> operandStack: anObject [

	operandStack := anObject
]

{ #category : #accessing }
RAVMFrame >> operandStackSize [
	
	^ {operandStack size . frameConstraints operandStackSize }
]

{ #category : #initialization }
RAVMFrame >> pop [

	^ operandStack pop
]

{ #category : #initialization }
RAVMFrame >> push: aValue [

	operandStack push: aValue
]

{ #category : #accessing }
RAVMFrame >> receiver [

	^ receiver
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
