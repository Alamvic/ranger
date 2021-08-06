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
RAPathExplorer >> explore: aSelector on: anObject vmBuildingBlock: aBuildingBlock [

	| currentPath solution currentConstraints |
	self initializeWithSelector: aSelector onVM: anObject.

	solution := RAConstraintSolution new solver: #initial.
	currentConstraints := (numberOfArguments to: 0 by: -1) collect: [ :e | 
		                      | smallInteger |
		                      smallInteger := objectBuilder
			                                      newAbstractObject.
		                      smallInteger typeTag value: 1.
		                      smallInteger integerValue value: 0.
		                      smallInteger ].
	[ 
	currentPath := (self
		 explorePathWithConstraints: currentConstraints
		 solver: solution solver)
			ifNil: [ (currentPath ifNil: [ RAPath new ]) nextPath ].

	"Negate and solve constraints!"
	solution := self solve: currentPath withInterpreter: anObject.
	currentConstraints := solution path inputs collect: [ :e | e second ].
	self initializeWithSelector: aSelector onVM: aBuildingBlock value.
	
	solution isEmpty ] whileFalse.
	^ solutions
]

{ #category : #api }
RAPathExplorer >> explorePathWithConstraints: constraintsToExplore solver: solver [

	| values path |
	[ 
	values := constraintsToExplore collect: [ :e | 
		          objectBuilder instantiate: e ].
	path := RASinglePathExplorer new
		        explore: selector
		        on: vm
		        withValues: values
		        explorer: self ]
		on: Exception
		do: [ :e | 
			failOnError ifTrue: [ e pass ].
			self recordSolution: (RAErrorSolution new
					 inputConstraints: constraintsToExplore;
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself).
			"Could not explore this path!"
			^ nil ].

	self recordSolution: (RAConstraintSolution new
			 inputConstraints: constraintsToExplore;
			 path: path;
			 solver: solver;
			 yourself).
	^ path
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
RAPathExplorer >> recordSolution: aSolution [

	solutions add: aSolution
]

{ #category : #solving }
RAPathExplorer >> solve: aRAPath withInterpreter: interpreter [

	^ self solveAtLeast: aRAPath pathConstraints size inPathConstraint: aRAPath withInterpreter: interpreter
]

{ #category : #solving }
RAPathExplorer >> solveAtLeast: ktry inPathConstraint: aRAPath withInterpreter: interpreter [

	| nextPath solution j |
	j := (executionStack first: (executionStack size min: ktry)) lastIndexOf: false.
	(j = 0 or: [ j > aRAPath pathConstraints size ]) ifTrue: [ 
		^ RAPath new solveWithInterpreter: interpreter ].

	nextPath := (aRAPath copyWithNumberOfSegments: j) nextPath.

	[ 
	[ solution := nextPath solveWithInterpreter: interpreter ]
		on: MzUnsatisfiable
		do: [ :e |
			^ self
				  solveAtLeast: j - 1
				  inPathConstraint: nextPath
				  withInterpreter: interpreter ] ]
		on: Exception
		do: [ :e |
			"If there is a timeout, record that this path has shown a bug in the solver
			Then retry with the next one"
			self recordSolution: (RAErrorSolution new
					 path: nextPath;
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself).

			^ self
				  solveAtLeast: j - 1
				  inPathConstraint: aRAPath
				  withInterpreter: interpreter ].

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
