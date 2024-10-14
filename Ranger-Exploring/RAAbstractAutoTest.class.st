Class {
	#name : 'RAAbstractAutoTest',
	#superclass : 'VMSimpleStackBasedCogitAbstractTest',
	#instVars : [
		'solution',
		'objectBuilder',
		'sendTrampolineStop'
	],
	#category : 'Ranger-Exploring-Tests',
	#package : 'Ranger-Exploring',
	#tag : 'Tests'
}

{ #category : 'building' }
RAAbstractAutoTest >> allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 [ 
	
	^ memory allocateNewSpaceSlots: anInteger format: anInteger2 classIndex: anInteger3 
]

{ #category : 'running' }
RAAbstractAutoTest >> createSpecialSelectorArray [

	| specialObjectsOop  |
	specialObjectsOop := self newObjectWithSlots: 100.
	obj := self newObjectWithSlots: Smalltalk specialSelectors size.
	memory storePointer: 23 ofObject: specialObjectsOop withValue: obj.
	memory specialObjectsOop: specialObjectsOop.
	
	0 to: Smalltalk specialSelectors size - 1 by: 2 do: [ :aSelectorIndex |
		sentSelector := Smalltalk specialSelectors at: aSelectorIndex + 1.
		"Some object to test"
		memory
			storePointer: aSelectorIndex
			ofObject: obj withValue: (selectorAtIndex := memory integerObjectOf: aSelectorIndex + 77).
		memory
			storePointer: aSelectorIndex + 1 
			ofObject: obj withValue: (memory integerObjectOf: (sentSelector) numArgs) ]
]

{ #category : 'testing' }
RAAbstractAutoTest >> instanceVariablesToKeep [

	^ super instanceVariablesToKeep, #( solution )
]

{ #category : 'executing' }
RAAbstractAutoTest >> isExpectedFailure [

	^ solution isErrorSolution
]

{ #category : 'testing' }
RAAbstractAutoTest >> isInvalidMemoryAccessInvalid [
	
	^ self subclassResponsibility
]

{ #category : 'running' }
RAAbstractAutoTest >> receiverTags [

	self subclassResponsibility
]

{ #category : 'running' }
RAAbstractAutoTest >> runCaseManaged [ 

	^ self runCase
]

{ #category : 'running' }
RAAbstractAutoTest >> setUp [

	super setUp.
	
	solution checkSupported.
	(solution isInvalidIn: self) ifTrue: [ ^ self ].
	
	cogit maybeGenerateCheckFeatures.
	self installFloatClass.
	self createSpecialSelectorArray.
	
	memory classExternalAddress: (self
			 newClassInOldSpaceWithSlots: 0
			 instSpec: (memory byteFormatForNumBytes: 0)).


	cogit receiverTags: self receiverTags.
	cogit methodOrBlockNumArgs: solution inputConstraints arguments size.
	
	self jitCompilerClass = SimpleStackBasedCogit ifFalse:[
		"Assume single bytecode set for the tests"
		cogit bytecodeSetOffset: 0. 
		cogit methodOrBlockNumTemps: solution inputConstraints locals size + solution inputConstraints arguments size.
		cogit initSimStackForFramefulMethod: 0.
		cogit regArgsHaveBeenPushed: false ].
	
	objectBuilder := RAObjectBuilder new
		                 interpreter: interpreter;
		                 nextIndex: nextIndex;
		                 yourself.
	
	"Install a send trampoline"
	sendTrampolineAddress := self compile: [ sendTrampolineStop := cogit Stop ].
	0 to: 3 do: [ :numberOfArguments |
		cogit ordinarySendTrampolineAt: numberOfArguments put: sendTrampolineAddress. ]
]

{ #category : 'running' }
RAAbstractAutoTest >> solution: aSolution [

	solution := aSolution
]
