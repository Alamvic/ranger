Class {
	#name : #RAASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'specialCases',
		'interpretationStack'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #API }
RAASTInterpreter >> basicNewFrame [
	
	^ RAAbstractStackFrame new
]

{ #category : #'frame-access' }
RAASTInterpreter >> currentFrame [
	
	^ interpretationStack last
]

{ #category : #visiting }
RAASTInterpreter >> doBasicMessageSend: aRBMessageNode [

	| method receiver arguments lookupClass |
	aRBMessageNode receiver acceptVisitor: self. "Resolve it as a normal send"
	receiver := self popOperand.
	arguments := aRBMessageNode arguments collect: [ :e | 
		             e acceptVisitor: self.
		             self popOperand ].
	lookupClass := aRBMessageNode isSuperSend
		ifTrue: [ self currentFrame method methodClass superclass ]
		ifFalse: [ receiver first class ].
	method := self lookupSelector: aRBMessageNode selector inClass: lookupClass.
	(method selector = #value and: [ lookupClass == RABlockClosure ]) 
		ifTrue: [ 
			^ self
				  interpretBlock: receiver first
				  receiver: receiver first home receiver
				  arguments: arguments ].
	method ast isPrimitive ifTrue: [ 
		^ self
			  interpretPrimitive: method
			  receiver: receiver
			  arguments: arguments ].
	self
		interpretMethod: method ast
		receiver: receiver
		arguments: arguments
]

{ #category : #API }
RAASTInterpreter >> initialize [

	super initialize.
	"Push a top frame"
	interpretationStack := OrderedCollection new.
	interpretationStack addLast: self basicNewFrame.
	
	specialCases := Dictionary new.
	self initializeSpecialCases.
]

{ #category : #API }
RAASTInterpreter >> initializeSpecialCases [

	"Hook to be redefined by subclasses"
]

{ #category : #interpreting }
RAASTInterpreter >> interpretBlock: aBlock receiver: aReceiver arguments: arguments [ 
	
	| returnedFrame |
	self pushFrameWithReceiver: aReceiver withMethod: aBlock ast withArguments: arguments.
	self currentFrame block: aBlock.
	aBlock ast argumentNames with: arguments do: [ :name :value |
		self temporaryAt: name put: value
	].
	[aBlock ast body acceptVisitor: self] ensure: [
		returnedFrame := self popFrame.
	].
	self pushOperand: returnedFrame pop.
]

{ #category : #'special cases' }
RAASTInterpreter >> interpretCCodeInSmalltalkWith: aRBMessageNode [ 
	"Interpret the Smalltalk version"
	^ aRBMessageNode arguments second body acceptVisitor: self
]

{ #category : #API }
RAASTInterpreter >> interpretMethod: aMethodAST receiver: aReceiver [

	^ self interpretMethod: aMethodAST receiver: aReceiver arguments: #()
]

{ #category : #API }
RAASTInterpreter >> interpretMethod: aMethodAST receiver: aReceiver arguments: arguments [
	| returnedFrame currentFrame |
	currentFrame := self
		pushFrameWithReceiver: aReceiver
		withMethod: aMethodAST
		withArguments: arguments.
	[ [aMethodAST acceptVisitor: self]
		on: RAReturnNotification
		do: [ :notification | 
			notification frameToReturnTo = currentFrame
				ifFalse: [ notification pass ] ].
	] ensure: [
		returnedFrame := self popFrame.
	].
	self pushOperand: returnedFrame returnValue.
]

{ #category : #visiting }
RAASTInterpreter >> interpretPrimitive: method receiver: receiver arguments: arguments [

	^ self pushOperand:
		  (receiver
			   perform: method selector
			   withArguments: arguments asArray)
]

{ #category : #lookup }
RAASTInterpreter >> lookupSelector: aString inReceiver: aReceiver [
	
	^ aReceiver class lookupSelector: aString
]

{ #category : #'frame-access' }
RAASTInterpreter >> operandStackTop [
	
	^ self currentFrame stackTop
]

{ #category : #API }
RAASTInterpreter >> popFrame [
	
	^ interpretationStack removeLast
]

{ #category : #'frame-access' }
RAASTInterpreter >> popOperand [

	^ self currentFrame pop
]

{ #category : #API }
RAASTInterpreter >> pushFrameWithReceiver: aReceiver withMethod: aMethod withArguments: arguments [
	
	| frame |
	frame := self basicNewFrame
		receiver: aReceiver;
		method: aMethod;
		yourself.
	interpretationStack addLast: frame.
	aMethod argumentNames with: arguments do: [ :name :value |
		self temporaryAt: name put: value
	].
	aMethod temporaryNames do: [ :name |
		self temporaryAt: name put: { 0 . RAConstant value: 0 }
	].
	^ frame
]

{ #category : #'frame-access' }
RAASTInterpreter >> pushOperand: anOperand [

	^ self currentFrame push: anOperand
]

{ #category : #'frame-access' }
RAASTInterpreter >> receiver [
	
	^ self currentFrame receiver
]

{ #category : #visiting }
RAASTInterpreter >> temporaryAt: aString [ 
	
	^ self currentFrame temporaryAt: aString
]

{ #category : #visiting }
RAASTInterpreter >> temporaryAt: aString put: aValue [
	
	^ self currentFrame temporaryAt: aString put: aValue
]

{ #category : #visiting }
RAASTInterpreter >> visitArgumentVariableNode: aRBVariableNode [ 
	
	^ self visitTemporaryVariableNode: aRBVariableNode 
]

{ #category : #visiting }
RAASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	
	aRBAssignmentNode value acceptVisitor: self.
	
	aRBAssignmentNode variable binding isTempVariable ifTrue: [ 
		^ self
			temporaryAt: aRBAssignmentNode variable name
			put: self operandStackTop ].
	
	aRBAssignmentNode variable binding isInstanceVariable ifTrue: [ 
		^ self receiver first instVarNamed: aRBAssignmentNode variable name put: self operandStackTop first ].
	
	self halt
]

{ #category : #visiting }
RAASTInterpreter >> visitInstanceVariableNode: aRBVariableNode [ 
	
	| receiver arguments method |
	specialCases
		at: aRBVariableNode name
		ifPresent: [ :mapping |
			^ self perform: mapping withArguments: { aRBVariableNode } ].
	
	self pushOperand: (self receiver instVarNamed: aRBVariableNode name)
]

{ #category : #visiting }
RAASTInterpreter >> visitLiteralValueNode: aRBLiteralValueNode [ 
	
	self pushOperand: aRBLiteralValueNode value
]

{ #category : #visiting }
RAASTInterpreter >> visitMessageNode: aRBMessageNode [

	(aRBMessageNode selector = #assert:) ifTrue: [ 
		"If this is an assert, ignore it.
		Make sure it is a stament, otherwise its value is used???"
		self assert: aRBMessageNode parent isSequence.
		self pushOperand: nil.
		^ self ].

	"Resolve it as a normal send"
	specialCases at: aRBMessageNode selector ifPresent: [ :mapping | 
		^ self perform: mapping withArguments: { aRBMessageNode } ].
	
	"Stop here if we are going far too low level..."
	self haltIf: [ #(assert: rawNumSlotsOf: byteAt: longAt: long32At: long64At:) includes: aRBMessageNode selector ].
	^ self doBasicMessageSend: aRBMessageNode
]

{ #category : #visiting }
RAASTInterpreter >> visitMethodNode: aRBMethodNode [ 
	
	aRBMethodNode body acceptVisitor: self.
	self popOperand.
]

{ #category : #visiting }
RAASTInterpreter >> visitReturnNode: aRBReturnNode [

	| result |
	aRBReturnNode value acceptVisitor: self.
	result := self popOperand.
	self currentFrame home return: result.
	(RAReturnNotification to: self currentFrame home) signal
]

{ #category : #visiting }
RAASTInterpreter >> visitSelfNode: aRBVariableNode [ 
	
	self pushOperand: self receiver
]

{ #category : #visiting }
RAASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 

	
	aRBSequenceNode statements allButLastDo: [ :each |
		each acceptVisitor: self.
		self currentFrame hasReturned ifTrue: [ ^ self ].
		self popOperand ].
	
	"The last value remaines pushed in the stack.
	It is up to the caller to decide what to do with it.
	If it is a block, it should return it to its caller.
	If it is a method, it should pop it and ignore it."
	aRBSequenceNode statements last acceptVisitor: self.
]

{ #category : #visiting }
RAASTInterpreter >> visitSuperNode: aRBVariableNode [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
RAASTInterpreter >> visitTemporaryVariableNode: aRBVariableNode [ 
	
	^ self pushOperand: (self temporaryAt: aRBVariableNode name)
]
