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
		'vm',
		'failOnError'
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

	| currentPath solution currentConstraints |
	self initializeWithSelector: aSelector onVM: anObject.

	solution := RAConstraintSolution new solver: #initial.
	currentConstraints := (numberOfArguments to: 0 by: -1)
		collect: [ :e | | smallInteger |
			smallInteger := objectBuilder newAbstractObject.
			smallInteger typeTag value: 1.
			smallInteger integerValue value: 0.
			smallInteger ].	
	[ 
	[ | initialValues |
	initialValues := currentConstraints
		collect: [ :e | objectBuilder instantiate: e ].
	currentPath := RASinglePathExplorer new
		               explore: selector
		               on: vm
		               withValues: initialValues
		               explorer: self.
	solutions add: (RAConstraintSolution new
		inputConstraints: currentConstraints;
		path: currentPath;
		solver: solution solver;
		yourself).

	"Negate and solve constraints!"
	solution := self solve: currentPath withInterpreter: anObject.
	currentConstraints := solution path inputs collect: [ :e | e second].
	solution isEmpty ] whileFalse ]
		on: Exception
		do: [ :e | 
			failOnError ifTrue: [ e pass ].
			solutions add: (RAErrorSolution new
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself) ].
	^ solutions
]

{ #category : #accessing }
RAPathExplorer >> failOnError [

	^ failOnError
]

{ #category : #accessing }
RAPathExplorer >> failOnError: anObject [

	failOnError := anObject
]

{ #category : #api }
RAPathExplorer >> initialize [

	super initialize.
	failOnError := true.
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
		nextIndex: 100;
		yourself
]

{ #category : #solving }
RAPathExplorer >> solve: aRAPath withInterpreter: interpreter [

	^ self solveAtLeast: aRAPath pathConstraints size inPathConstraint: aRAPath withInterpreter: interpreter
]

{ #category : #solving }
RAPathExplorer >> solveAtLeast: ktry inPathConstraint: aRAPath withInterpreter: interpreter [
	
	| nextPath solution j |
	j := (executionStack first: ktry) lastIndexOf: false.
	(j = 0 or: [j > aRAPath pathConstraints size])
		ifTrue: [ ^ RAPath new solveWithInterpreter: interpreter ].

	nextPath := (aRAPath copyWithNumberOfSegments: j) nextPath.

	[solution := nextPath solveWithInterpreter: interpreter]
		on: MzUnsatisfiable do: [ :e |
			^ self solveAtLeast: j - 1 inPathConstraint: aRAPath withInterpreter: interpreter ].

	executionStack := executionStack first: j.
	"Now we expect that the next iteration will go over the other branch at j"
	"executionStack at: j put: (executionStack at: j) not."
	^ solution
]

{ #category : #'execution stack' }
RAPathExplorer >> updateExecutionStackWithConditional: taken position: stackPosition [

	stackPosition "k" < executionStack size ifFalse: [ 
		executionStack add: false.
		^ self ].

	"Assert we are taking the branch we expect."
	"self assert: (executionStack at: stackPosition ""k"" + 1) = taken."

	(executionStack size - 1) = stackPosition "k" ifTrue: [
		executionStack at: stackPosition + 1 put: true ].
]
