Class {
	#name : #RASinglePathExplorer,
	#superclass : #RAASTInterpreter,
	#instVars : [
		'constraints',
		'paths',
		'pathConstraints',
		'explorer',
		'vmFrame',
		'path',
		'interpreter'
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
RASinglePathExplorer >> exitCondition [
	
	^ interpreter primFailCode ~= 0
		ifTrue: [ RAPrimitiveFailure new ]
		ifFalse: [ RASuccess new "Could be a primitive or a bytecode success!" ]
		
]

{ #category : #api }
RASinglePathExplorer >> explore: aSelector on: vm withFrame: aFrame explorer: anExplorer [

	| method |
	explorer := anExplorer.
	interpreter := vm.
	method := vm class lookupSelector: aSelector.

	vmFrame := aFrame.

	vm primFailCode: 0.
	vm argumentCount: aFrame operandStackSize - 1 "Should not count the message receiver".

	path := RAPath new.
	path inputFrame: aFrame.
	path pathConstraints: pathConstraints.
	[ 
		self interpretMethod: method ast receiver: { 
			vm.
			(RAConstant value: vm) }.
		path exitCondition: self exitCondition
	]	on: Exception
		do: [ :error | 
			path exitCondition: error freeze.
			(error isKindOf: RAInterpreterEndError)
				ifFalse: [ error pass ] ].
	^ path
]

{ #category : #api }
RASinglePathExplorer >> initialize [

	super initialize.
	constraints := OrderedCollection new.
	pathConstraints := OrderedCollection new.
	
	vmFrame := RAVMFrame new.
	paths := OrderedCollection new
]

{ #category : #initialization }
RASinglePathExplorer >> initializeSpecialCases [

	"Stack access"
	specialCases at: #receiver put: #interpretReceiverWith:.
	specialCases at: #iframeNumArgs: put: #interpretiFrameNumArgsWith:.
	specialCases
		at: #iArgumentForFramePointer:atOffset:
		put: #interpretiArgumentForFramePointerAtOffsetWith:.
	specialCases
		at: #iLocalForFramePointer:atOffset:
		put: #interpretiLocalForFramePointerAtOffsetWith:.
	specialCases at: #literal: put: #interpretLiteralWith:.

	specialCases at: #stackTop put: #interpretStackTopWith:.
	specialCases at: #internalStackTopPut: put: #interpretStackTopPutWith:.
	specialCases at: #stackValue: put: #interpretStackValueWith:.
	specialCases at: #internalStackTop put: #interpretStackTopWith:.
	specialCases at: #internalStackValue: put: #interpretStackValueWith:.

	specialCases at: #internalPop: put: #interpretPopWith:.
	specialCases at: #pop:thenPush: put: #interpretPopThenPushWith:.
	specialCases at: #internalPop:thenPush: put: #interpretPopThenPushWith:.
	
	specialCases at: #pop:thenPushBool: put: #interpretPopThenPushBoolWith:.
	specialCases at: #pop:thenPushFloat: put: #interpretPopThenPushFloatWith:.
	specialCases at: #pop:thenPushInteger: put: #interpretPopThenPushIntWith:.
	specialCases at: #internalPush: put: #interpretInternalPushWith:.
	
	specialCases at: #fetchByte put: #interpretNoopWith:.
	specialCases at: #externalizeIPandSP put: #interpretNoopWith:.
	specialCases at: #internalizeIPandSP put: #interpretNoopWith:.
	
	"Object format"
	specialCases at: #formatOf: put: #interpretFormatOfObjectWith:.
	specialCases at: #fetchClassOfNonImm: put: #interpretFetchClassOfNonImmWith:.
	specialCases at: #fetchClassOf: put: #interpretFetchClassOfWith:.
	specialCases at: #fetchClassTagOf: put: #interpretFetchClassTagOfWith:.
	
	specialCases at: #fixedFieldsOfClass: put: #interpretFixedFieldsOfClassWith:.

	specialCases at: #numSlotsOf: put: #interpretNumSlotsOfWith:.
	specialCases at: #lengthOf:format: put: #interpretLengthOfFormatWith:.
	specialCases at: #numSlotsOfAny: put: #interpretNumSlotsOfAnyWith:.

	specialCases at: #numBytesOfBytes: put: #interpretNumBytesOfBytesWith:.
	specialCases at: #rawHashBitsOf: put: #interpretRawHashBitsOfWith:.

	
	specialCases at: #fetchLong32:ofObject: put: #interpretFetchLong32OfObjectWith:.
	specialCases at: #fetchFloat:into: put: #interpretFetchFloatIntoWith:.
	specialCases at: #fetchPointer:ofObject: put: #interpretFetchPointerOfObjectWith:.
	
	specialCases at: #integerValueOf: put: #interpretIntegerValueOfWith:.
	specialCases at: #integerObjectOf: put: #interpretIntegerObjectOfWith:.
	specialCases at: #isIntegerValue: put: #interpretIsIntegerValueWith:.
	specialCases at: #isIntegerObject: put: #interpretIsIntegerObjectWith:.
	specialCases at: #isNonIntegerObject: put: #interpretIsNonIntegerObjectWith:.

	specialCases at: #isCharacterObject: put: #interpretIsCharacterObjectWith:.
	specialCases at: #characterValueOf: put: #interpretCharacterValueOfWith:.

	specialCases at: #isImmediate: put: #interpretIsImmediateWith:.
	specialCases at: #isNonImmediate: put: #interpretIsNonImmediateWith:.
	specialCases at: #isForwarded: put: #interpretIsForwardedWith:.
	specialCases at: #areIntegers:and: put: #interpretAreIntegersAreWith:.
	specialCases at: #isContextObject: put: #interpretIsContextObjectWith:.
	specialCases at: #classIndexOf: put: #interpretClassIndexOfWith:.
	
	specialCases at: #byteSwapped32IfBigEndian: put: #interpretByteSwapped32IfBigEndianWith:.
	specialCases at: #byteSwapped64IfBigEndian: put: #interpretByteSwapped64IfBigEndianWith:.
		
	"special variables"
	specialCases at: #trueObj put: #interpretTrueObjectWith:.
	specialCases at: #falseObj put: #interpretFalseObjectWith:.
	specialCases at: #specialSelector: put: #interpretSpecialSelectorWith:.
	
	specialCases at: #splObj: put: #interpretSpecialObjectWith:.
	specialCases at: #maybeSplObj: put: #interpretSpecialObjectWith:.
	
	"special simulation cases"
	specialCases at: #cCode:inSmalltalk: put: #interpretCCodeInSmalltalkWith:.
	specialCases at: #sizeof: put: #interpretSizeofWith:.
	specialCases at: #cCoerceSimple:to: put: #interpretCCoerceSimpleToWith:.

	
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
	
	specialCases at: #commonSendOrdinary put: #interpretCommonSendOrdinaryWith:
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
			self pushOperand: { condition first. condition second copy } ]
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
RASinglePathExplorer >> interpretByteSwapped32IfBigEndianWith: aRBMessageNode [ 
	
	| value vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	value := self popOperand.

	concreteValue := vm first byteSwapped32IfBigEndian: value first.
	
	self pushOperand: {
		concreteValue.
		"Do nothing"
		value
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretByteSwapped64IfBigEndianWith: aRBMessageNode [ 
	
	| value vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	value := self popOperand.

	concreteValue := vm first byteSwapped64IfBigEndian: value first.
	
	self pushOperand: {
		concreteValue.
		"Do nothing"
		value
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretCCoerceSimpleToWith: aRBMessageNode [ 
	
	| object vm concreteValue type |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	object := self popOperand.

	aRBMessageNode arguments second acceptVisitor: self.
	type := self popOperand.

	concreteValue := vm first cCoerceSimple: object first to: type first.
	self pushOperand: {
		concreteValue.
		RAConstant value: concreteValue
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretCharacterValueOfWith: aRBMessageNode [ 
	
	| smallInteger receiver |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.

	self pushOperand: {
		(receiver first characterValueOf: smallInteger first).
		smallInteger second integerValue
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
RASinglePathExplorer >> interpretCommonSendOrdinaryWith: aRBMessageNode [ 
	
	RASendExit signal
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
RASinglePathExplorer >> interpretFetchClassOfWith: aRBMessageNode [ 
	
	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first fetchClassOf: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second classObject
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFetchClassTagOfWith: aRBMessageNode [ 
	
	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first fetchClassTagOf: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second classTag
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFetchFloatIntoWith: aRBMessageNode [ 

	| float vm concreteValue floatoop |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	floatoop := self popOperand.
	
	aRBMessageNode arguments second acceptVisitor: self.
	float := self popOperand.

	concreteValue := vm first fetchFloat: floatoop first into: float first.	
	
	self pushOperand: {
		concreteValue.
		floatoop second
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFetchLong32OfObjectWith: aRBMessageNode [ 

	| oop vm concreteValue index |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	index := self popOperand.
	
	aRBMessageNode arguments second acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first fetchLong32: index first ofObject: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second fetchLong32: index
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretFetchPointerOfObjectWith: aRBMessageNode [

	| oop vm concreteValue index numberOfPointersInObject constraint |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	index := self popOperand.

	aRBMessageNode arguments second acceptVisitor: self.
	oop := self popOperand.

	"Checked access. If we access an immediate or outside the bounds of the object just use 0 as concrete value.
	The abstract value will contain bound checks"
	(vm first isImmediate: oop first)
		ifTrue: [ "Record it was an immediate"
			self
				addPathConstraint: (RANotEqualsConstraint operands: { 
							 oop second typeTag.
							 (RAConstant value: 0) })
				taken: true.
			"Push 0 "
			self pushOperand: { 
					0.
					(RAObject named: 'invalid') } ]
		ifFalse: [ 
			self
				addPathConstraint: (RAEqualsConstraint operands: { 
							 oop second typeTag.
							 (RAConstant value: 0) })
				taken: true.
			constraint := RALessConstraint operands: { 
				index second.
				oop second numSlots }.
			numberOfPointersInObject := vm first numSlotsOfAny: oop first.
			concreteValue := index first < numberOfPointersInObject
				                 ifTrue: [ 
					                 self
						                 addPathConstraint: constraint
						                 taken: true.
					                 vm first
						                 fetchPointer: index first
						                 ofObject: oop first ]
				                 ifFalse: [ 
					                 self
						                 addPathConstraint: constraint negated
						                 taken: false.
					                 RAInvalidMemoryAccess signal ] ]
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
		(receiver first formatOf: oop first).
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
			self addPathConstraint: condition second negated taken: true.
			aRBMessageNode arguments first body acceptVisitor: self ]
		ifTrue: [ 
			self addPathConstraint: condition second taken: false.
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
RASinglePathExplorer >> interpretInternalPushWith: aRBMessageNode [ 
	
	| elementsToPop elementToPush |
	aRBMessageNode arguments first acceptVisitor: self.
	elementToPush := self popOperand.
	self push: elementToPush.

	"pop:thenPush: does not return an interesting value"
	self pushOperand: self receiver.
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretIsCharacterObjectWith: aRBMessageNode [ 
	
	| smallInteger receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	smallInteger := self popOperand.
	concreteValue := receiver first isCharacterObject: smallInteger first.
	
	self pushOperand: {
		concreteValue.
		RAIsCharacterObject operands: { smallInteger second }
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
RASinglePathExplorer >> interpretIsNonImmediateWith: aRBMessageNode [ 
	
	| maybeImmediate receiver concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	maybeImmediate := self popOperand.
	
	concreteValue := receiver first isNonImmediate: maybeImmediate first.

	self pushOperand: {
		concreteValue.
		RAEqualsConstraint
			operands: { 
				maybeImmediate second typeTag.
				RAConstant value: 0 }
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
RASinglePathExplorer >> interpretLengthOfFormatWith: aRBMessageNode [ 

	| oop vm concreteValue format |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.
	
	aRBMessageNode arguments second acceptVisitor: self.
	format := self popOperand.

	concreteValue := vm first lengthOf: oop first format: format first.
	
	self pushOperand: {
		concreteValue.
		oop second numSlots
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretLiteralWith: aRBMessageNode [

	| vm concreteValue index numberOfLiterals |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.

	aRBMessageNode arguments first acceptVisitor: self.
	index := self popOperand.

	"Checked access. If we access an immediate or outside the bounds of the object just use 0 as concrete value.
	The abstract value will contain bound checks"
	numberOfLiterals := vm first objectMemory literalCountOf: vmFrame method first.
	concreteValue := index first < numberOfLiterals
		                 ifTrue: [ 
			                 self
				                 addPathConstraint:
					                 (RALessConstraint operands: { 
							                  index second.
							                  vmFrame method second numSlots })
				                 taken: true.
			                 vm first
				                 literal: index first
				                 ofMethod: vmFrame method first ]
		                 ifFalse: [ 
			                 self
				                 addPathConstraint:
					                 (RAGreaterOrEqualsConstraint operands: { 
							                  index second.
							                  vmFrame method second numSlots })
				                 taken: false.
			                 RAInvalidMemoryAccess signal ].

	self pushOperand: { 
			concreteValue.
			vmFrame method second fetchPointer: index second }
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretNoopWith: aRBMessageNode [ 

	self pushOperand: self receiver
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretNumBytesOfBytesWith: aRBMessageNode [ 

	"Special case to avoid interpreting bit ands"
	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first numBytesOfBytes: oop first.	
	
	"
	This should compute: 
		slots << shiftForWord - (format bitAnd: 7)
	However, we only do on the abstract side: 
		slots * (2 ^ shiftForWord)
	This makes the result less exact but easier to interpret/solve.
	The constraint solver does not manage bit wise operations (yet).
	Thus
	 - transform the bit shift into a multiplication
	 - do not remove the padding because is computed as format bitAnd: 7"
	self pushOperand: {
		concreteValue.
		RAMultiplicationConstraint operands: { 
			oop second numSlots.
			RAConstant value: (2 raisedTo: vm first shiftForWord)
		}
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
RASinglePathExplorer >> interpretNumSlotsOfWith: aRBMessageNode [ 

	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first numSlotsOf: oop first.	
	
	self pushOperand: {
		concreteValue.
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
RASinglePathExplorer >> interpretPopThenPushFloatWith: aRBMessageNode [ 

	"Pop N elements from the operand stack.
	Pushes the second argument to the stack.
	
	Pop: keep track of the operand stack and remove one element
	Push: move the value to the physical register assigned to the current stack position"
	
	| elementsToPop vm float concreteFloatObject |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	elementsToPop := self popOperand.
	elementsToPop first isInteger
		ifFalse: [ self error: 'expected an integer value' ].	
	aRBMessageNode arguments second acceptVisitor: self.
	self pop: elementsToPop first.
	
	float := self popOperand.
	concreteFloatObject := vm first objectMemory floatObjectOf: float first.
	self push: { concreteFloatObject . RAFloatObjectOf operands: float second }.

	"pop:thenPush: does not return an interesting value"
	self pushOperand: self receiver.
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretPopThenPushIntWith: aRBMessageNode [ 

	"Pop N elements from the operand stack.
	Pushes the second argument to the stack.
	
	Pop: keep track of the operand stack and remove one element
	Push: move the value to the physical register assigned to the current stack position"
	
	| elementsToPop vm float concreteIntegerObject |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	elementsToPop := self popOperand.
	elementsToPop first isInteger
		ifFalse: [ self error: 'expected an integer value' ].	
	aRBMessageNode arguments second acceptVisitor: self.
	self pop: elementsToPop first.

	float := self popOperand.
	concreteIntegerObject := vm first objectMemory integerObjectOf: float first.
	self push: { concreteIntegerObject . RAIntegerObjectOf operands: float second }.

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

{ #category : #'special cases' }
RASinglePathExplorer >> interpretPopWith: aRBMessageNode [ 

	"Pop N elements from the operand stack"
	
	| elementsToPop |
	aRBMessageNode arguments first acceptVisitor: self.
	elementsToPop := self popOperand.
	elementsToPop first isInteger
		ifFalse: [ self error: 'expected an integer value' ].	
	self pop: elementsToPop first.

	"pop: does not return an interesting value"
	self pushOperand: self receiver.
]

{ #category : #visiting }
RASinglePathExplorer >> interpretPrimitive: method receiver: receiver arguments: arguments [

	| concreteReceiver concreteArguments concreteResult constraintArguments constraintOperands constraint |
	concreteReceiver := receiver first.
	concreteArguments := arguments collect: [ :e | e first ].
	concreteResult := concreteReceiver
	   perform: method selector
	   withArguments: concreteArguments asArray.
	
	constraintArguments := arguments collect: [ :e | e second ].

	"Do constant folding if possible"
	constraintOperands := { receiver second }, constraintArguments.
	constraint :=(constraintOperands allSatisfy: [ :e | e isConstant ])
		ifTrue: [ RAConstant value: concreteResult ]
		ifFalse: [ 
			RAConstraint
				operation: method selector
				operands: constraintOperands ].

	^ self pushOperand: { concreteResult . constraint }
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretRawHashBitsOfWith: aRBMessageNode [ 

	| oop vm concreteValue |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	oop := self popOperand.

	concreteValue := vm first rawHashBitsOf: oop first.	
	
	self pushOperand: {
		concreteValue.
		oop second hashBits
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretReceiverWith: aRBMessageNode [ 

	self pushOperand: vmFrame receiver
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretSizeofWith: aRBMessageNode [ 
	
	| object vm concreteSizeOf |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	object := self popOperand.

	concreteSizeOf := vm first sizeof: object first.
	self pushOperand: {
		concreteSizeOf.
		RAConstant value: concreteSizeOf
	}
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

	abstractSpecialObject := (RAObject named: UUID new asString)
		typeTag: 0;
		specialObjectIndex: operand second;
		yourself.
	
	self pushOperand: { vm splObj: index . abstractSpecialObject }
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretSpecialSelectorWith: aRBMessageNode [ 
	
	| receiver selectorIndex |
	aRBMessageNode receiver acceptVisitor: self.
	receiver := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	selectorIndex := self popOperand.

	self pushOperand: {
		"Just push a small integer that represents the index"
		(receiver first objectMemory integerObjectOf: selectorIndex first).
		RAConstant value: selectorIndex.
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackAt: indexPair [

	| constraint |
	constraint := RAAndConstraint operands: { 
			              (RAGreaterOrEqualsConstraint operands: { 
					               indexPair second.
					               (RAConstant value: 0) }).
			              (RALessConstraint operands: { 
					               indexPair second.
					               vmFrame operandStackSize second }) }.
	(indexPair first between: 0 and: vmFrame operandStackSize first - 1)
		ifTrue: [ 
			self addPathConstraint: constraint taken: true.
			self pushOperand: (vmFrame operandStackAt: indexPair first + 1) ]
		ifFalse: [ 
			self addPathConstraint: constraint negated taken: true.
			RAInvalidMemoryAccess signal ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackTopPutWith: aRBMessageNode [

	| constraint value |
	
	aRBMessageNode arguments first acceptVisitor: self.
	value := self popOperand.
	
	constraint := RALessConstraint operands: { 
               RAConstant value: 0.
               vmFrame operandStackSize second }.
	(0 < vmFrame operandStackSize first)
		ifTrue: [ 
			self addPathConstraint: constraint taken: true.
			vmFrame operandStackAt: 1 put: value.
			self pushOperand: self receiver ]
		ifFalse: [ 
			self addPathConstraint: constraint negated taken: true.
			RAInvalidMemoryAccess signal ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackTopWith: aRBMessageNode [ 

	self interpretStackAt: { 
		0.
		RAConstant value: 0
	}
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretStackValueWith: aRBMessageNode [

	"Interpret messages of the form 
	interpreter stackValue: xxx.
	"

	| indexPair |
	aRBMessageNode arguments first acceptVisitor: self.
	indexPair := self popOperand.
	self interpretStackAt: indexPair
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretiArgumentForFramePointerAtOffsetWith: aRBMessageNode [ 
	
	| vm index constraint |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.

	aRBMessageNode arguments second acceptVisitor: self.
	index := self popOperand.

	constraint := RAAndConstraint operands: { 
		(RAGreaterOrEqualsConstraint operands: { 
			 index second.
			 RAConstant value: 0 }).
		(RALessOrEqualsConstraint operands: { 
			 index second.
			 vmFrame numberOfArguments second })
	}.
	(index first between: 0 and: vmFrame numberOfArguments first)
		ifTrue: [ 
			self
				addPathConstraint: constraint
				taken: true.
			self pushOperand: (vmFrame argumentAt: index first) ]
		ifFalse: [ 
			self
				addPathConstraint: constraint negated
				taken: true.
			RAInvalidMemoryAccess signal ]
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretiFrameNumArgsWith: aRBMessageNode [ 
	
	| vm theMessageFP |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.
	
	aRBMessageNode arguments first acceptVisitor: self.
	theMessageFP := self popOperand.
	
	"We only implement single frames for now, if it wants to access some other frame, we need to implement it"
	self assert: vm first localFP = theMessageFP first.

	self pushOperand: vmFrame numberOfArguments.
]

{ #category : #'special cases' }
RASinglePathExplorer >> interpretiLocalForFramePointerAtOffsetWith: aRBMessageNode [

	| vm index constraint |
	aRBMessageNode receiver acceptVisitor: self.
	vm := self popOperand.

	aRBMessageNode arguments second acceptVisitor: self.
	index := self popOperand.

	constraint := RAAndConstraint operands: {
		RAGreaterOrEqualsConstraint operands: { 
			index second.
			RAConstant value: 0
		}.
		(RALessConstraint operands: { 
			 index second.
			 vmFrame numberOfLocals second })
	}.
	(index first between: 0 and: vmFrame numberOfLocals first - 1)
		ifTrue: [ 
			self
				addPathConstraint: constraint
				taken: true.
			self pushOperand: (vmFrame localAt: index second) ]
		ifFalse: [ 
			self
				addPathConstraint: constraint negated
				taken: true.
			RAInvalidMemoryAccess signal ]
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
RASinglePathExplorer >> path [
	
	^ path
]

{ #category : #accessing }
RASinglePathExplorer >> paths [
	
	^ paths
]

{ #category : #'vm stack' }
RASinglePathExplorer >> pop: anInteger [ 
	
	anInteger timesRepeat: [ vmFrame pop ]
]

{ #category : #initialization }
RASinglePathExplorer >> popAbstractOperand [

	^ self currentFrame popAbstractOperand
]

{ #category : #'vm stack' }
RASinglePathExplorer >> push: anInteger [ 
	
	vmFrame push: anInteger
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
RASinglePathExplorer >> visitGlobalVariableNode: aRBVariableNode [ 

	^ self visitClassVariableNode: aRBVariableNode
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
