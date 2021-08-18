Class {
	#name : #RAVMFrameConstraint,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'operandStack',
		'method',
		'arguments',
		'locals',
		'numberOfLocals',
		'numberOfArguments',
		'operandStackSize'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #accessing }
RAVMFrameConstraint >> argumentAt: anIndex [

	^ arguments at: anIndex
]

{ #category : #accessing }
RAVMFrameConstraint >> argumentAt: anInteger ifAbsent: aFullBlockClosure [ 
	
	^ arguments at: anInteger ifAbsent: aFullBlockClosure 
]

{ #category : #accessing }
RAVMFrameConstraint >> arguments [

	^ arguments
]

{ #category : #accessing }
RAVMFrameConstraint >> arguments: aCollection [

	arguments := aCollection
]

{ #category : #initialization }
RAVMFrameConstraint >> initialize [

	super initialize.
	operandStack := Stack new.
	locals := OrderedCollection new.
	arguments := #().
	numberOfArguments := MzVariable new
		name: 'frame_number_of_arguments';
		type: '0..1000' "A thousand arguments variables is more than enough to test...";
		yourself.
	numberOfLocals := MzVariable new
		name: 'frame_number_of_locals';
		type: '0..1000' "A thousand local variables is more than enough to test...";
		yourself. 
	operandStackSize := MzVariable new
		name: 'frame_operand_stack_size';
		type: '0..1000' "A thousand stack elements is more than enough to test...";
		yourself. 
]

{ #category : #instantiation }
RAVMFrameConstraint >> instantiateWith: aRAObjectBuilder constraintBuilder: aRAConstraintBuilder [
	
	| frame newConstraints concreteLocals abstractLocals concreteArguments abstractArguments concreteObject |
	newConstraints := RAVMFrameConstraint new.
	frame := RAVMFrame new.
	frame frameConstraints: newConstraints.
	
	frame receiver: (aRAObjectBuilder instantiate: receiver).
	newConstraints receiver: receiver.
	
	frame method: (aRAObjectBuilder instantiate: method).
	newConstraints method: method.
	
	concreteLocals := OrderedCollection new.
	abstractLocals := OrderedCollection new.
	((1 to: (numberOfLocals value ifNil: [ 0 ])) collect: [ :e | | abstractLocal |
		abstractLocal := self localAt: e ifAbsent: [ aRAConstraintBuilder newAbstractObject ].
		concreteLocals add: (aRAObjectBuilder instantiate: abstractLocal).
		abstractLocals add: abstractLocal.
	]).
	frame locals: concreteLocals.
	newConstraints locals: abstractLocals.

	concreteArguments := OrderedCollection new.
	abstractArguments := OrderedCollection new.
	((1 to: (numberOfArguments value ifNil: [ 0 ])) collect: [ :e | | abstractArgument |
		abstractArgument := self argumentAt: e ifAbsent: [ aRAConstraintBuilder newAbstractObject ].
		concreteArguments add: (aRAObjectBuilder 
			instantiate: abstractArgument).
		abstractArguments add: abstractArgument.
	]).
	frame arguments: concreteArguments.
	newConstraints arguments: abstractArguments.
	
	(((operandStackSize evaluate ifNil: [ 0 ]) to: 1 by: -1) collect: [ :e | | abstractStackValue |
		abstractStackValue := self operandAt: e ifAbsent: [ aRAConstraintBuilder newAbstractObject ].
		concreteObject := aRAObjectBuilder instantiate: abstractStackValue.
		frame push: {concreteObject . abstractStackValue }
	]).

	^ frame
]

{ #category : #accessing }
RAVMFrameConstraint >> localAt: anIndex [
	
	^ locals at: anIndex
]

{ #category : #accessing }
RAVMFrameConstraint >> localAt: anInteger ifAbsent: aFullBlockClosure [ 
	
	^ locals at: anInteger ifAbsent: aFullBlockClosure
]

{ #category : #accessing }
RAVMFrameConstraint >> locals [

	^ locals
]

{ #category : #accessing }
RAVMFrameConstraint >> locals: aCollection [ 
	locals := aCollection
]

{ #category : #method }
RAVMFrameConstraint >> method [
	
	^ method
]

{ #category : #accessing }
RAVMFrameConstraint >> method: anObject [

	method := anObject
]

{ #category : #accessing }
RAVMFrameConstraint >> numberOfArguments [

	^ numberOfArguments
]

{ #category : #accessing }
RAVMFrameConstraint >> numberOfLocals [
	
	^ numberOfLocals
]

{ #category : #accessing }
RAVMFrameConstraint >> operandAt: anInteger ifAbsent: aBlock [
	
	^ operandStack at: anInteger ifAbsent: aBlock
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStack [

	^ operandStack
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStack: anObject [

	operandStack := anObject
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStackAt: stackIndex [ 

	^ operandStack at: stackIndex
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStackAt: stackIndex put: aValue [

	operandStack
		at: stackIndex
		put: aValue
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStackSize [
	
	^ operandStackSize
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStackSize: anObject [

	operandStackSize := anObject
]

{ #category : #accessing }
RAVMFrameConstraint >> operandStackTop [
	
	^ operandStack top
]

{ #category : #initialization }
RAVMFrameConstraint >> postCopy [

	locals := locals copy.
	arguments := arguments copy.
	operandStack := operandStack copy.
]

{ #category : #accessing }
RAVMFrameConstraint >> push: anOperandConstraint [

	operandStack push: anOperandConstraint.
	operandStackSize := operandStackSize + 1
]

{ #category : #accessing }
RAVMFrameConstraint >> receiver [

	^ receiver
]

{ #category : #accessing }
RAVMFrameConstraint >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
RAVMFrameConstraint >> top [
	self shouldBeImplemented.
]
