Class {
	#name : #RAPathExplorerTests,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #'Ranger-Tests'
}

{ #category : #tests }
RAPathExplorerTests >> setUp [

	| theMemory |
	super setUp.
	theMemory := Spur64BitCoMemoryManager simulatorClass new.
	CogVMSimulatorLSB
		initializeWithOptions: {
			#BytesPerWord. 8.
			#ObjectMemory. theMemory class name.
			#bytecodeTableInitializer. #initializeBytecodeTableForSqueakV3PlusClosures}
			objectMemoryClass: theMemory class.
	interpreter := RATestInterpreter basicNew
		objectMemory: theMemory;
		basicInitialize.
]

{ #category : #tests }
RAPathExplorerTests >> testEmptyPathIsEmpty [

	self assert: RAPath new isEmpty
]

{ #category : #tests }
RAPathExplorerTests >> testEqualsConditional [

	| paths firstConstraints secondConstraints |
	paths := RASinglePathExplorer explore: #primitiveSimpleConditional on: interpreter.
	self assert: paths size equals: 2.
	
	firstConstraints := paths first pathConstraints.
	self assert: firstConstraints first variableName equals: 'stack-0'.
	self assert: firstConstraints first constraint equals: '='.
	self assert: firstConstraints first expression equals: 0.
	
	secondConstraints := paths second pathConstraints.
	self assert: secondConstraints first variableName equals: 'stack-0'.
	self assert: secondConstraints first constraint equals: '~='.
	self assert: secondConstraints first expression equals: 0.
]

{ #category : #tests }
RAPathExplorerTests >> testNextNextPathOfDoubleConstraintNegatesFirst [

	| path constraints |
	path := RAPath new pathConstraints: { 
		RAConstraint
			operation: #=
			operands: { RAVariable named: 'y' . RAConstant value: 100 }.
		RAConstraint
			operation: #=
			operands: { RAVariable named: 'x' . RAConstant value: 10 } }.
	
	constraints := path nextPath nextPath pathConstraints.
	self assert: constraints size equals: 1.
	
	"The first constraint should remain the same"
	self assert: constraints first operation equals: '~='
]

{ #category : #tests }
RAPathExplorerTests >> testNextNextPathOfSingleConstraintPathIsEmpty [

	| path |
	path := RAPath new pathConstraints: { RAConstraint
		operation: #=
		operands: { RAVariable named: 'x' . RAConstant value: 10 } }.
	
	self assert: path nextPath nextPath isEmpty
]

{ #category : #tests }
RAPathExplorerTests >> testNextPathOfDoubleConstraintPathNegatedOnlyLast [

	| path firstConstraint secondConstraint |
	path := RAPath new pathConstraints: { 
		RAConstraint
			operation: #=
			operands: { RAVariable named: 'y' . RAConstant value: 100 }.
		RAConstraint
			operation: #=
			operands: { RAVariable named: 'x' . RAConstant value: 10 } }.
	
	firstConstraint := path nextPath pathConstraints first.
	"The first constraint should remain the same"
	self assert: firstConstraint equals: path pathConstraints first.
	
	"And the second one should be negated"
	secondConstraint := path nextPath pathConstraints last.
	self assert: secondConstraint operation equals: #'~='.
	self assert: secondConstraint operands first name equals: 'x'.
	self assert: secondConstraint operands second value equals: 10.
]

{ #category : #tests }
RAPathExplorerTests >> testNextPathOfEmptyPathIsEmpty [

	self assert: RAPath new nextPath isEmpty
]

{ #category : #tests }
RAPathExplorerTests >> testNextPathOfSingleConstraintPathIsNegated [

	| path constraint |
	path := RAPath new pathConstraints: { RAConstraint
		operation: #=
		operands: { RAVariable named: 'x' . RAConstant value: 10 } }.
	
	constraint := path nextPath pathConstraints first.
	self assert: constraint operation equals: #'~='.
	self assert: constraint operands first name equals: 'x'.
	self assert: constraint operands second value equals: 10.
]

{ #category : #tests }
RAPathExplorerTests >> testNoConditional [

	| paths firstConstraints |
	paths := RASinglePathExplorer explore: #primitiveNoConditional on: interpreter.
	self assert: paths size equals: 1.
	
	self assert: paths first isEmpty
]
