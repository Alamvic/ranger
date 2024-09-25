Class {
	#name : 'RAPathExplorer',
	#superclass : 'Object',
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
		'constraintFactory',
		'mutator'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'accessing' }
RAPathExplorer >> constraintFactory [

	^ constraintFactory
]

{ #category : 'api' }
RAPathExplorer >> explore: aConcolicCase vmBuildingBlock: aBuildingBlock [

	| currentPath solution previousInputFrameConstraints exploredPath inputFrame |
	selector := aConcolicCase selector.

	currentPath := RAPath new.
	solution := RAConstraintSolution new solver: #initial.

	previousInputFrameConstraints := RAVMFrameConstraint new
		newFrameConstraintForSolution: MzSolver new
		constraintFactory: constraintFactory.

	[ | timeToExplore |
	timeToExplore := [| objectBuilder |
	vm := aBuildingBlock value.
	objectBuilder := RAObjectBuilder new
		                 interpreter: vm;
		                 nextIndex: 100;
		                 yourself.
	aConcolicCase initializeVM: vm.

	inputFrame := previousInputFrameConstraints
		              instantiateWith: objectBuilder
		              constraintBuilder: constraintFactory.
		
	exploredPath := self
		                explorePathWithFrame: inputFrame
		                solver: solution solver.

	"If we do not get an explored path (to see if this is still happening)
	This may be because there was an exception while doing the interpretation.
	Continue by negating the going to the next path.
	Can this loop?"
	currentPath := (exploredPath ifNil: [ currentPath nextPath ]) veryDeepCopy.

	"Negate and solve constraints!"
	solution := self solve: currentPath.

	previousInputFrameConstraints := previousInputFrameConstraints
		newFrameConstraintForSolution: solution solver
		constraintFactory: constraintFactory.] timeToRun.
	solutions last timeToExplore: timeToExplore.
	solution isEmpty ] whileFalse.
	^ solutions
]

{ #category : 'api' }
RAPathExplorer >> exploreAndMutate: aConcolicCase vmBuildingBlock: aBuildingBlock [
	
	| interpreter |
	
	interpreter := aBuildingBlock value.

	^((self explore: aConcolicCase vmBuildingBlock: aBuildingBlock) inject: OrderedCollection new writeStream into: [
		:stream :solution |
			stream nextPutAll: { solution };
			nextPutAll: (self solutionMutations: solution withInterpreter: interpreter);
			yourself
	]) contents

]

{ #category : 'api' }
RAPathExplorer >> explorePathWithFrame: inputFrame solver: solver [

	| explorer outputFrame |
	[ 
	outputFrame := inputFrame copy.
	explorer := RASinglePathExplorer new.
	explorer
		explore: selector
		on: vm
		withFrame: outputFrame
		explorer: self.
	self recordSolution: (RAConstraintSolution new
			 inputConstraints: inputFrame frameConstraints;
			 outputConstraints: outputFrame frameConstraints;
			 path: explorer path;
			 solver: solver;
			 yourself) ]
		on: Exception
		do: [ :e | 
			failOnError ifTrue: [ e pass ].
			self recordSolution: (RAErrorSolution new
					 inputConstraints: inputFrame frameConstraints;
					 outputConstraints: outputFrame frameConstraints;
					 vm: vm;
					 selector: selector;
					 error: e freeze;
					 yourself) ].
	^ explorer path
]

{ #category : 'accessing' }
RAPathExplorer >> failOnError [

	^ failOnError
]

{ #category : 'accessing' }
RAPathExplorer >> failOnError: anObject [

	failOnError := anObject
]

{ #category : 'api' }
RAPathExplorer >> initialize [

	super initialize.
	failOnError := true.
	executionStack := OrderedCollection new.
	solutions := OrderedCollection new.
	constraintFactory := RAConstraintFactory new.
	mutator := RAPathMutator lastestPathMutator.
]

{ #category : 'as yet unclassified' }
RAPathExplorer >> mutator [

	^ mutator 
]

{ #category : 'as yet unclassified' }
RAPathExplorer >> mutator: aMutator [

	mutator := aMutator 
]

{ #category : 'as yet unclassified' }
RAPathExplorer >> pathMutations: pathToMutate [ "{ constraints, inputs, expected }"
	"Given a path, we use our mutator to generate all possible different mutations"

	^ mutator mutatePath: pathToMutate
]

{ #category : 'solving' }
RAPathExplorer >> recordSolution: aSolution [

	solutions add: aSolution
]

{ #category : 'as yet unclassified' }
RAPathExplorer >> solutionMutations: solution withInterpreter: interpreter [ 

	^ (self pathMutations: solution path) collect: [ :path | path solveWithInterpreter: interpreter ]

]

{ #category : 'solving' }
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

{ #category : 'execution stack' }
RAPathExplorer >> updateExecutionStackWithConditional: taken position: stackPosition [

	stackPosition "k" < executionStack size ifFalse: [ 
		executionStack add: false.
		^ self ].

	"Assert we are taking the branch we expect."
	"self assert: (executionStack at: stackPosition ""k"" + 1) = taken."

	(executionStack size - 1) = stackPosition "k" ifTrue: [
		executionStack at: stackPosition + 1 put: true ].
]
