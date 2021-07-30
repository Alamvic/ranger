Class {
	#name : #RAPathExplorer,
	#superclass : #Object,
	#instVars : [
		'vmStack',
		'constraints',
		'paths',
		'pathConstraints',
		'executionStack'
	],
	#category : #Ranger
}

{ #category : #api }
RAPathExplorer class >> explore: aSelector on: anObject [
	
	^ self new
		explore: aSelector on: anObject
]

{ #category : #api }
RAPathExplorer >> explore: aSelector on: anObject [
	
	| method numberOfArguments currentPath initialValues solutions solution objectBuilder |
	method := anObject class lookupSelector: aSelector.
	numberOfArguments := (method ast pragmaNamed: #numberOfArguments:) arguments first value.
	solutions := OrderedCollection new.

	objectBuilder := RAObjectBuilder new
		interpreter: anObject;
		nextIndex: 17;
		yourself.
	
	currentPath := RAPath new.
	solution := currentPath solveWithInterpreter: anObject.
	[
	initialValues := (numberOfArguments "0 based because of Receiver" to: 0 by: -1)
		collect: [ :e | objectBuilder instantiate: (solution stackValue: e) ].
	solution numberOfArguments: numberOfArguments.
	solutions add: solution.
	currentPath := RASinglePathExplorer new
		explore: aSelector
		on: anObject
		withValues: initialValues
		explorer: self.
	solution path: currentPath.
	solution := self solve: currentPath withInterpreter: anObject.
	solution isEmpty ] whileFalse.
	^ solutions
]

{ #category : #api }
RAPathExplorer >> initialize [

	super initialize.
	executionStack := OrderedCollection new.
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
