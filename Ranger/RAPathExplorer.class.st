Class {
	#name : #RAPathExplorer,
	#superclass : #Object,
	#instVars : [
		'vmStack',
		'constraints',
		'paths',
		'pathConstraints',
		'executionStack',
		'solutions',
		'objectBuilder',
		'numberOfArguments',
		'selector',
		'vm'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #api }
RAPathExplorer class >> explore: aSelector on: anObject [
	
	^ self new
		explore: aSelector on: anObject
]

{ #category : #api }
RAPathExplorer >> explore: aSelector on: anObject [
	
	| currentPath solution |
	
	self initializeWithSelector: aSelector onVM: anObject.
	
	currentPath := RAPath new.
	solution := currentPath solveWithInterpreter: anObject.
	[[
	currentPath := self exploreSolution: solution.
	solution path: currentPath.
	solution numberOfArguments: numberOfArguments.
	solutions add: solution.
	
	solution := self solve: currentPath withInterpreter: anObject.
	solution isEmpty ] whileFalse.]
		 on: Error do: [ :e |
			solutions add: (RAErrorSolution new
				selector: aSelector;
				vm: anObject;
				error: e freeze;
				yourself) ].
	^ solutions
]

{ #category : #api }
RAPathExplorer >> exploreSolution: solution [

	| initialValues |
	initialValues := (numberOfArguments "0 based because of Receiver" to: 0 by: -1)
		collect: [ :e | objectBuilder instantiate: (solution stackValue: e) ].
	
	^ RASinglePathExplorer new
		explore: selector
		on: vm
		withValues: initialValues
		explorer: self
]

{ #category : #api }
RAPathExplorer >> initialize [

	super initialize.
	executionStack := OrderedCollection new.
	solutions := OrderedCollection new
]

{ #category : #api }
RAPathExplorer >> initializeWithSelector: aSelector onVM: aVM [
	
	| method |
	selector := aSelector.
	vm := aVM.
	
	method := aVM class lookupSelector: aSelector.
	numberOfArguments := (method ast pragmaNamed: #numberOfArguments:) arguments first value.
	objectBuilder := RAObjectBuilder new
		interpreter: aVM;
		nextIndex: 17;
		yourself
]

{ #category : #solving }
RAPathExplorer >> solve: aRAPath withInterpreter: interpreter [
	
	| nextPath solution j |
	j := (executionStack lastIndexOf: false).
	(j = 0 or: [j > aRAPath pathConstraints size]) ifTrue: [ ^ RAPath new solveWithInterpreter: interpreter ].

	nextPath := (aRAPath copyWithNumberOfSegments: j) nextPath.
	solution := nextPath solveWithInterpreter: interpreter.
	executionStack := executionStack first: j.
	"Now we expect that the next iteration will go over the other branch at j"
	executionStack at: j put: (executionStack at: j) not.
	^ solution
]

{ #category : #'execution stack' }
RAPathExplorer >> updateExecutionStackWithConditional: taken position: stackPosition [

	executionStack size <= stackPosition ifTrue: [ 
		executionStack add: false.
		^ self ].

	"Assert we are taking the branch we expect."
	"self assert: (executionStack at: stackPosition + 1) = taken."

	(executionStack size = (stackPosition + 1)) ifTrue: [
		executionStack at: stackPosition + 1 put: true ].
]
