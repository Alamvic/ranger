Class {
	#name : #RASinglePathExplorer,
	#superclass : #RAASTInterpreter,
	#instVars : [
		'vmStack',
		'constraints',
		'paths',
		'pathConstraints',
		'explorer'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #constraints }
RASinglePathExplorer >> addPathConstraint: aPathConstraint taken: aBoolean [

	"Do not add constant conditions"
	aPathConstraint isConstant
		ifTrue: [ ^ self ].
"	(aPathConstraint operands allSatisfy: [ :e | e isConstant ])
		ifTrue: [ ^ self ].
"
	explorer
		updateExecutionStackWithConditional: aBoolean
		position: pathConstraints size.
	aPathConstraint origin: thisContext stack copy.
	pathConstraints add: aPathConstraint
]

{ #category : #initialization }
RASinglePathExplorer >> basicNewFrame [
	
	^ RAStackFrame new
]

{ #category : #api }
RASinglePathExplorer >> explore: aSelector on: anObject withValues: values explorer: anExplorer [

	| method |
	explorer := anExplorer.
	method := anObject class lookupSelector: aSelector.
	self initializeVMStackWithArguments: values.
	anObject primFailCode: 0.
	anObject argumentCount: values size - 1.
	self interpretMethod: method ast receiver: { anObject . RAConstant value: anObject }.
	^ RAPath new
		inputs: values;
		pathConstraints: pathConstraints;
		failure: anObject primFailCode ~= 0;
		yourself
]

{ #category : #api }
RASinglePathExplorer >> initialize [

	super initialize.
	constraints := OrderedCollection new.
	pathConstraints := OrderedCollection new.
	
	vmStack := Stack new.
	paths := OrderedCollection new
]

{ #category : #initialization }
RASinglePathExplorer >> initializeSpecialCases [

	"Stack access"
	specialCases at: #stackTop put: #interpretStackTopWith:.
	specialCases at: #stackValue: put: #interpretStackValueWith:.
	specialCases at: #pop:thenPush: put: #interpretPopThenPushWith:.
	specialCases at: #pop:thenPushBool: put: #interpretPopThenPushBoolWith:.
	
	"Object format"
	specialCases at: #formatOfObject: put: #interpretFormatOfObjectWith:.
	specialCases at: #fetchClassOfNonImm: put: #interpretFetchClassOfNonImmWith:.
	specialCases at: #fixedFieldsOfClass: put: #interpretFixedFieldsOfClassWith:.
	
	specialCases at: #integerValueOf: put: #interpretIntegerValueOfWith:.
	specialCases at: #integerObjectOf: put: #interpretIntegerObjectOfWith:.
	specialCases at: #isIntegerValue: put: #interpretIsIntegerValueWith:.
	specialCases at: #isIntegerObject: put: #interpretIsIntegerObjectWith:.
	specialCases at: #isNonIntegerObject: put: #interpretIsNonIntegerObjectWith:.
	specialCases at: #isImmediate: put: #interpretIsImmediateWith:.
	specialCases at: #isForwarded: put: #interpretIsForwardedWith:.
	specialCases at: #areIntegers:and: put: #interpretAreIntegersAreWith:.
	specialCases at: #isContextObject: put: #interpretIsContextObjectWith:.
	specialCases at: #numSlotsOfAny: put: #interpretNumSlotsOfAnyWith:.
	specialCases at: #classIndexOf: put: #interpretClassIndexOfWith:.
		
	"special variables"
	specialCases at: #trueObj put: #interpretTrueObjectWith:.
	specialCases at: #falseObj put: #interpretFalseObjectWith:.
	specialCases at: #splObj: put: #interpretSpecialObjectWith:.
	
	"special simulation cases"
	specialCases at: #cCode:inSmalltalk: put: #interpretCCodeInSmalltalkWith:.
	
	"Conditions -- to add constraints"
"	specialCases at: #~= put: #interpretNotEqualsWith:.
	specialCases at: #= put: #interpretEqualsWith:."
	
	specialCases at: #or: put: #interpretOrWith:.
	specialCases at: #and: put: #interpretAndWith:.
	specialCases at: #ifTrue: put: #interpretIfTrueWith:.
	specialCases at: #ifFalse: put: #interpretIfFalseWith:.
	specialCases at: #ifTrue:ifFalse: put: #interpretIfTrueifFalseWith:.
	specialCases at: #ifNil: put: #interpretIfNilWith:.
	specialCases at: #ifNotNil: put: #interpretIfNotNilWith:.
	specialCases at: #ifNil:ifNotNil: put: #interpretIfNilIfNotNilWith:.
	specialCases at: #cppIf:ifTrue: put: #interpretCppIfIfTrueWith:.
	specialCases at: #cppIf:ifTrue:ifFalse: put: #interpretCppIfIfTrueIfFalseWith:.
	
]

{ #category : #initialization }
RASinglePathExplorer >> initializeVMStackWithArguments: values [ 
	
	values do: [ :e | self push: e ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretAndWith: aRBMessageNode [ 
	
	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifTrue: [ 
			self addPathConstraint: condition second taken: true.
			aRBMessageNode arguments first body acceptVisitor: self ]
		ifFalse: [ 
			self addPathConstraint: condition second negated taken: false.
			self pushOperand: condition ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretAreIntegersAreWith: aRBMessageNode [ 
	
	| smallInteger receiver concreteValue smallInteger2 |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.
	aRBMessageNode arguments second acceptVisitor: self.
	smallInteger2 := self popOperand.
	
	concreteValue := receiver first areIntegers: smallInteger first and: smallInteger2 first.

	self pushOperand: {
		concreteValue.
		RAAndConstraint operands: {
			RAEqualsConstraint operands: { 
				smallInteger second typeTag.
				RAConstant value: 1
			}.
			RAEqualsConstraint operands: { 
				smallInteger2 second typeTag.
				RAConstant value: 1
			}
		}
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretClassIndexOfWith: aRBMessageNode [ 
	
	| object vm |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	object := self popOperand.

	self pushOperand: {
		vm first classIndexOf: object first.
		object second classIndex
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretCppIfIfTrueIfFalseWith: aRBMessageNode [ 

	| condition |
	aRBMessageNode arguments first acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifTrue: [ 
			self addPathConstraint: condition second taken: true.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments second
					home: self currentFrame)
				receiver: self receiver
				arguments: #() ]
		ifFalse: [ 
			self addPathConstraint: condition second negated taken: false.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments third
					home: self currentFrame)
				receiver: self receiver
				arguments: #() ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFetchClassOfNonImmWith: aRBMessageNode [ 
	
	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first fetchClassOfNonImm: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second classObject
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFixedFieldsOfClassWith: aRBMessageNode [ 

	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first fixedFieldsOfClass: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second definedFixedFields
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFormatOfObjectWith: aRBMessageNode [ 
	
	| oop receiver |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	self pushOperand: {
		(receiver first formatOfObject: oop first).
		oop second format
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIfFalseWith: aRBMessageNode [ 
	
	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifFalse: [ 
			self addPathConstraint: condition second taken: true.
			aRBMessageNode arguments first body acceptVisitor: self ]
		ifTrue: [ 
			self addPathConstraint: condition second negated taken: false.
			self pushOperand: { nil . nil } ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIfNilIfNotNilWith: aRBMessageNode [ 
	
	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifNil: [ 
			self addPathConstraint: condition second taken: true.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments first
					home: self currentFrame)
				receiver: self receiver
				arguments: #() ]
		ifNotNil: [ 
			self addPathConstraint: condition second negated taken: false.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments second
					home: self currentFrame)
				receiver: self receiver
				arguments: { condition } ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIfTrueWith: aRBMessageNode [ 
	
	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifTrue: [ 
			self addPathConstraint: condition second taken: true.
			aRBMessageNode arguments first body acceptVisitor: self ]
		ifFalse: [ 
			self addPathConstraint: condition second negated taken: false.
			self pushOperand: { nil . nil } ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIfTrueifFalseWith: aRBMessageNode [

	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifTrue: [ 
			self addPathConstraint: condition second taken: true.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments first
					home: self currentFrame)
				receiver: self receiver
				arguments: #() ]
		ifFalse: [ 
			self addPathConstraint: condition second negated taken: false.
			self
				interpretBlock: (RABlockClosure
					on: aRBMessageNode arguments second
					home: self currentFrame)
				receiver: self receiver
				arguments: #() ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIntegerObjectOfWith: aRBMessageNode [ 
	
	| smallInteger receiver |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.

	self pushOperand: {
		(receiver first integerObjectOf: smallInteger first).
		(RAObject named: UUID new asString)
		  typeTag: 1 asMzValue;
		  integerValue: smallInteger second;
		  yourself
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIntegerValueOfWith: aRBMessageNode [ 
	
	| smallInteger receiver |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.

	self pushOperand: {
		(receiver first integerValueOf: smallInteger first).
		smallInteger second integerValue
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsContextObjectWith: aRBMessageNode [ 
	
	| receiver concreteValue oop |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.
	
	concreteValue := receiver first isContextObject: oop first.

	self pushOperand: {
		concreteValue.
		RAEqualsConstraint operands: { 
			oop second classIndex . 
			RAConstant value: (receiver first class bindingOf: #ClassMethodContextCompactIndex) value }
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsForwardedWith: aRBMessageNode [ 
	
	| maybeImmediate receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	maybeImmediate := self popOperand.
	
	concreteValue := receiver first isForwarded: maybeImmediate first.
1halt.
	self pushOperand: {
		concreteValue.
		RAIsForwardedObject operands: { maybeImmediate second }
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsImmediateWith: aRBMessageNode [ 
	
	| maybeImmediate receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	maybeImmediate := self popOperand.
	
	concreteValue := receiver first isImmediate: maybeImmediate first.

	self pushOperand: {
		concreteValue.
		RAGreaterConstraint
			operands: { 
				maybeImmediate second typeTag.
				RAConstant value: 0 }
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsIntegerObjectWith: aRBMessageNode [ 
	
	| smallInteger receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.
	
	concreteValue := receiver first isIntegerObject: smallInteger first.
	
	self pushOperand: {
		concreteValue.
		RAIsIntegerObject operands: { smallInteger second }
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsIntegerValueWith: aRBMessageNode [ 
	
	| smallInteger receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.
	concreteValue := receiver first isIntegerValue: smallInteger first.	
	self pushOperand: {
		concreteValue.
		self
			isInSmallIntegerRangeConstraintFor: smallInteger second
			inInterpreter: receiver first
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsNonIntegerObjectWith: aRBMessageNode [ 
	
	| smallInteger receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.
	
	concreteValue := receiver first isNonIntegerObject: smallInteger first.
	
	self pushOperand: {
		concreteValue.
		RAIsNonIntegerObject operands: { smallInteger second }
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretNumSlotsOfAnyWith: aRBMessageNode [ 
	
	| oop receiver |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	self pushOperand: {
		(receiver first numSlotsOfAny: oop first).
		oop second numSlots
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretOrWith: aRBMessageNode [ 
	
	| condition |
	aRBMessageNode receiver acceptVisitor: self.
	condition := self popOperand.
	condition first
		ifTrue: [ 
			self addPathConstraint: condition second taken: true.
			self pushOperand: { condition first. condition second copy } ]
		ifFalse: [ 
			self addPathConstraint: condition second negated taken: false.
			aRBMessageNode arguments first body acceptVisitor: self ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretPopThenPushBoolWith: aRBMessageNode [ 

	"Pop N elements from the operand stack.
	Pushes the second argument to the stack.
	
	Pop: keep track of the operand stack and remove one element
	Push: move the value to the physical register assigned to the current stack position"
	
	| elementsToPop vm boolean concreteBooleanObject |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	elementsToPop := self popOperand.
	elementsToPop first isInteger
		ifFalse: [ self error: 'expected an integer value' ].	
	aRBMessageNode arguments second acceptVisitor: self.
	self pop: elementsToPop first.
	
	boolean := self popOperand.
	concreteBooleanObject := vm first objectMemory booleanObjectOf: boolean first.
	self push: { concreteBooleanObject . RABooleanObjectOf operands: boolean second }.

	"pop:thenPush: does not return an interesting value"
	self pushOperand: self receiver.
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretPopThenPushWith: aRBMessageNode [ 

	"Pop N elements from the operand stack.
	Pushes the second argument to the stack.
	
	Pop: keep track of the operand stack and remove one element
	Push: move the value to the physical register assigned to the current stack position"
	
	| elementsToPop |
	aRBMessageNode arguments first acceptVisitor: self.
	elementsToPop := self popOperand.
	elementsToPop first isInteger
		ifFalse: [ self error: 'expected an integer value' ].	
	aRBMessageNode arguments second acceptVisitor: self.
	self pop: elementsToPop first.
	self push: self popOperand.

	"pop:thenPush: does not return an interesting value"
	self pushOperand: self receiver.
]

{ #category : #visiting }
RASinglePathExplorer >> interpretPrimitive: method receiver: receiver arguments: arguments [

	| concreteReceiver concreteArguments concreteResult constraintArguments |
	concreteReceiver := receiver first.
	concreteArguments := arguments collect: [ :e | e first ].
	concreteResult := concreteReceiver
	   perform: method selector
	   withArguments: concreteArguments asArray.
	
	constraintArguments := arguments collect: [ :e | e second ].

	^ self pushOperand: {
		concreteResult.
		RAConstraint
			operation: method selector
			operands: ({ receiver second }, constraintArguments) }
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretSpecialObjectWith: aRBMessageNode [ 
	
	| vm index operand abstractSpecialObject |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand first.
	
	aRBMessageNode arguments first acceptVisitor: self.
	operand := self popOperand.
	self assert: operand second isConstant.
	index := operand first.

	1halt.
	abstractSpecialObject := (RAObject named: UUID new asString)
		typeTag: 0 "Normal object";
		specialObjectIndex: operand second;
		yourself "Native value".
	
	self pushOperand: { vm splObj: index . abstractSpecialObject }
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackTopWith: aRBMessageNode [ 

	self pushOperand: vmStack top
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackValueWith: aRBMessageNode [

	"Interpret messages of the form 
	interpreter stackValue: xxx.
	"	
	| value |
	aRBMessageNode arguments first acceptVisitor: self.
	value := self popOperand first.
	value isInteger ifFalse: [ self error: 'expected an integer value' ].

	self pushOperand: (vmStack at: value + 1)
]

{ #category : #'special cases' }
RASinglePathExplorer >> isInSmallIntegerRangeConstraintFor: aConstraint inInterpreter: anInterpreter [

	^ RAAndConstraint operands: {
			RAGreaterOrEqualsConstraint operands: { 
				aConstraint.
				RAConstant value: anInterpreter minSmallInteger.
			}.
			RALessOrEqualsConstraint operands: { 
				aConstraint.
				RAConstant value: anInterpreter maxSmallInteger.
			}.
		}
]

{ #category : #'special cases' }
RASinglePathExplorer >> lookupSelector: aString inClass: aClass [
	
	^ aClass lookupSelector: aString
]

{ #category : #'special cases' }
RASinglePathExplorer >> lookupSelector: aString inReceiver: aReceiver [
	
	^ aReceiver first class lookupSelector: aString
]

{ #category : #accessing }
RASinglePathExplorer >> paths [
	
	^ paths
]

{ #category : #'vm stack' }
RASinglePathExplorer >> pop: anInteger [ 
	
	anInteger timesRepeat: [ vmStack pop ]
]

{ #category : #initialization }
RASinglePathExplorer >> popAbstractOperand [

	^ self currentFrame popAbstractOperand
]

{ #category : #'vm stack' }
RASinglePathExplorer >> push: anInteger [ 
	
	vmStack push: anInteger
]

{ #category : #visiting }
RASinglePathExplorer >> visitBlockNode: aRBBlockNode [ 
	
	| closure |
	closure := RABlockClosure on: aRBBlockNode home: self currentFrame.
	self pushOperand: {closure . closure}
]

{ #category : #visiting }
RASinglePathExplorer >> visitClassVariableNode: aRBVariableNode [ 
	
	| value |
	value := (self receiver first class bindingOf: aRBVariableNode name) value.
	self pushOperand: {
		value.
		RAConstant value: value
		}
]

{ #category : #visiting }
RASinglePathExplorer >> visitInstanceVariableNode: aRBVariableNode [ 
	
	| value |
	specialCases
		at: aRBVariableNode name
		ifPresent: [ :mapping |
			^ self perform: mapping withArguments: { aRBVariableNode } ].
	
	value := self receiver first instVarNamed: aRBVariableNode name.
	self pushOperand: {
		value.
		RAConstant value: value
		}
]

{ #category : #visiting }
RASinglePathExplorer >> visitLiteralValueNode: aRBLiteralValueNode [ 
	
	self pushOperand: {aRBLiteralValueNode value . RAConstant value: aRBLiteralValueNode value }
]

{ #category : #visiting }
RASinglePathExplorer >> visitSelfNode: aRBVariableNode [ 
	
	self pushOperand: self receiver
]
