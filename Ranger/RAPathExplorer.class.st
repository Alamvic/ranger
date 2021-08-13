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
		'selector',
		'vm',
		'failOnError',
		'constraintFactory'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #api }
RAPathExplorer >> explore: aConcolicCase vmBuildingBlock: aBuildingBlock [

	| currentPath solution previousInputFrameConstraints exploredPath inputFrame outputFrame |
	selector := aConcolicCase selector.
	currentPath := RAPath new.
	solution := RAConstraintSolution new solver: #initial.

	previousInputFrameConstraints := RAVMFrameConstraint new.
	previousInputFrameConstraints receiver:
		constraintFactory newAbstractSmallInteger.
	previousInputFrameConstraints method:
		constraintFactory newAbstractMethod.

	[ 
	| objectBuilder |
	vm := aBuildingBlock value.
	objectBuilder := RAObjectBuilder new
		                 interpreter: vm;
		                 nextIndex: 100;
		                 yourself.
	aConcolicCase initializeVM: vm.
	inputFrame := previousInputFrameConstraints
		              instantiateWith: objectBuilder
		              constraintBuilder: constraintFactory.
	outputFrame := inputFrame copy.
	exploredPath := self
		                explorePathWithFrame: outputFrame
		                solver: solution solver.

	"If we do not get an explored path (to see if this is still happenning)
	This may be because there was an exception while doing the interpretation.
	Continue by negating the going to the next path.
	Can this loop?"
	currentPath := exploredPath ifNil: [ currentPath nextPath ].

	"Negate and solve constraints!"
	solution := self solve: currentPath.
	previousInputFrameConstraints := inputFrame frameConstraints.
	solution isEmpty ] whileFalse.
	^ solutions
]

{ #category : #api }
RAPathExplorer >> explorePathWithFrame: aFrame solver: solver [

	| explorer |
	[
	explorer := RASinglePathExplorer new.
	explorer
		explore: selector
		on: vm
		withFrame: aFrame
		explorer: self.
	self recordSolution: (RAConstraintSolution new
			 inputConstraints: aFrame frameConstraints;
			 path: explorer path;
			 solver: solver;
			 yourself) ]
		on: Exception
		do: [ :e | 
			failOnError ifTrue: [ e pass ].
			self recordSolution: (RAErrorSolution new
					 inputConstraints: aFrame frameConstraints;
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself) ].
	^ explorer path
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
	solutions := OrderedCollection new.
	constraintFactory := RAConstraintFactory new
]

{ #category : #solving }
RAPathExplorer >> recordSolution: aSolution [

	solutions add: aSolution
]

{ #category : #solving }
RAPathExplorer >> solve: aRAPath [

	| nextPath solution j ktry |
	ktry :=  aRAPath pathConstraints size.
	j := (executionStack first: (executionStack size min: ktry)) 
		     lastIndexOf: false.
	(j = 0 or: [ j > aRAPath pathConstraints size ]) ifTrue: [ 
		^ RAPath new solveWithInterpreter: vm ].

	nextPath := (aRAPath copyWithNumberOfSegments: j) nextPath.

	[ 
	[ solution := nextPath solveWithInterpreter: vm ]
		on: MzUnsatisfiable
		do: [ :e | ^ self solve: (aRAPath copyWithNumberOfSegments: ktry - 1) ] ]
		on: Error
		do: [ :e | "If there is a timeout, record that this path has shown a bug in the solver
			Then retry with the next one"
			self recordSolution: (RAErrorSolution new
					 path: nextPath;
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself).

			^ self solve: (aRAPath copyWithNumberOfSegments: ktry - 1) ].

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
