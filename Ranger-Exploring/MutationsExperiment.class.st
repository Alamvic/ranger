Class {
	#name : 'MutationsExperiment',
	#superclass : 'Object',
	#instVars : [
		'runner',
		'cached'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'accessing' }
MutationsExperiment class >> bytecodesWithAllMutations [

	self new bytecodesWithAllMutations
]

{ #category : 'accessing' }
MutationsExperiment class >> main [

	self new main
]

{ #category : 'accessing' }
MutationsExperiment class >> makeFileWith: tempDict at: fileName [

   | jsonString writeStream |
	jsonString := NeoJSONWriter toStringPretty: tempDict.

   writeStream := fileName asFileReference createFile writeStream.
   writeStream nextPutAll: jsonString.
   writeStream close




]

{ #category : 'accessing' }
MutationsExperiment class >> maximumReachableCoverage [

	self new maximumReachableCoverage
]

{ #category : 'accessing' }
MutationsExperiment class >> maximumReachableCoverageWithoutMutations [

	self new maximumReachableCoverageWithoutMutations
]

{ #category : 'accessing' }
MutationsExperiment class >> primitivesWithAllMutations [

	self new primitivesWithAllMutations
]

{ #category : 'accessing' }
MutationsExperiment class >> runBytecode: bytecode [

	self new runBytecode: bytecode
]

{ #category : 'accessing' }
MutationsExperiment class >> segmentedMutationExperiment [

	self new segmentedMutationExperiment
]

{ #category : 'accessing' }
MutationsExperiment >> allPossibleCasesFor: type [
	
	| cases |
	
	cases := self minimizedCasesForType: type.
	^ cases, (self mutators flatCollect: [ :mutator | self mutatedCases: cases mutator: mutator prefix: type , '_minimized' ]).
]

{ #category : 'accessing' }
MutationsExperiment >> allPossibleCasesFor: type number: num [
	
	| cases |
	
	cases := self minimizedCasesForType: type number: num.
	^ cases, (self mutators flatCollect: [ :mutator | self mutatedCases: cases mutator: mutator prefix: type , num asString, '_minimized' ]).
]

{ #category : 'accessing' }
MutationsExperiment >> baseCasesForType: aType [
	"Basic cases"

	^ self
		  execute: [
			  ('Computing cases: ' , aType) traceCr.
			  runner getReasonableCases:
				  (runner perform: #casesForAll , aType capitalized) ]
		  cached: aType, '_base_cases'
]

{ #category : 'accessing' }
MutationsExperiment >> baseCasesForType: aType number: num [
	"Basic cases"

	^ self
		  execute: [
			  ('Computing cases: ' , aType) traceCr.
			  runner getReasonableCases:
				  (runner perform: #casesFor, aType capitalized allButLast, ':' with: num) ]
		  cached: aType, num asString, '_base_cases'
]

{ #category : 'accessing' }
MutationsExperiment >> bytecodesWithAllMutations [
	
	| primitiveCases |
	
	primitiveCases := self allPossibleCasesFor: 'bytecodes'.
	RAConcolicRunner runAndMeasure: primitiveCases with: RABytecodeAutoTest new at: 'bytecodesWithAllMutations.json'.
]

{ #category : 'accessing' }
MutationsExperiment >> cached [

	^ cached 
]

{ #category : 'accessing' }
MutationsExperiment >> cached: boolean [

	cached := boolean 
]

{ #category : 'accessing' }
MutationsExperiment >> casesFor: aType [
	"aType: { bytecodes, primitives }"

	^ self
		  execute: [
			  ('Computing cases: ' , aType) traceCr.
			  runner perform: #casesForAll , aType capitalized ]
		  cached: 'cases_' , aType
]

{ #category : 'accessing' }
MutationsExperiment >> difference: dict1 with: dict2 andSaveIn: fileName [

	| differenceResult collectorResult nodes collector |
	differenceResult := dict2 associations inject: dict1 into: [ :dict :assc |
		dict at: assc key ifPresent: [ | difference |
			difference := ((dict at: assc key) difference: assc value).
			difference ifEmpty: [ dict removeKey: assc key ] ifNotEmpty: [ dict at: assc key put: difference ]
		].
		dict.
	].
	collector := C2CoverageCollector new methods: CompilerCoverageCollector.
	differenceResult associations do: [ :assc | | method |
		method := Object readFrom: assc key.
		assc value do: [ :path | collector coverNode: path inMethod: method name ]
	].
	collectorResult := collector result collectResult: collector.
	^ CompilerCoverageCollector
		generateCompilerCoverage: differenceResult
		withFails: {}
		at: fileName
	
]

{ #category : 'accessing' }
MutationsExperiment >> execute: aBlock cached: aCacheName [
	"aType: { bytecodes, primitives }"

	| cachedFile result |
	
	cached ifFalse: [ ^ aBlock value ].
	
	cachedFile := aCacheName asFileReference, 'ston'.
	cachedFile exists ifTrue: [
		('Found cached file: ', cachedFile fullName) traceCr.
		^ STON fromStream: cachedFile readStream.
	].

	"If not found in the cache"	
	('Not found cached file: ', cachedFile fullName) traceCr.

	result := aBlock value.
	
	"Caching"
	('Caching into: ', cachedFile fullName) traceCr.
	cachedFile writeStreamDo: [ :stream |
		STON put: result onStreamPretty: stream
	].
	^ result
]

{ #category : 'accessing' }
MutationsExperiment >> initialize [

	super initialize.
	runner := RAConcolicRunner new.
	cached := true.
]

{ #category : 'accessing' }
MutationsExperiment >> jsonFrom: fileName [

	^ NeoJSONReader fromString: fileName asFileReference createFile.
]

{ #category : 'accessing' }
MutationsExperiment >> main [

	#( bytecodes primitives ) do: [ :type |
		self main: type ]
]

{ #category : 'accessing' }
MutationsExperiment >> main: type [

	('Processing: ', type) traceCr.

	self
		run: type
		cases: (self minimizedCasesForType: type)
		prefix: 'minimized'.

	self mutators do: [ :mutator |
		self
			mutatedCases: (self baseCasesForType: type)
			mutator: mutator
			prefix: type , '_base'.
		self
			mutatedCases: (self minimizedCasesForType: type)
			mutator: mutator
			prefix: type , '_minimized'.
		self
			run: type
			cases: (self
					 mutatedCases: (self minimizedCasesForType: type)
					 mutator: mutator
					 prefix: type , '_minimized')
			prefix: mutator class name ]
]

{ #category : 'accessing' }
MutationsExperiment >> maximumReachableCoverage [
	
	| cases |
	cases := #( bytecodes primitives ) flatCollect: [ :type | self allPossibleCasesFor: type ].	

	RAConcolicRunner runAndMeasure: cases with: RAPrimitiveAutoTest new at: 'maximumReachableCoverage.json'.
]

{ #category : 'accessing' }
MutationsExperiment >> maximumReachableCoverageWithoutMutations [
	
	| cases |
	cases := #( bytecodes primitives ) flatCollect: [ :type | self minimizedCasesForType: type ].	

	^ RAConcolicRunner runAndMeasure: cases with: RAPrimitiveAutoTest new at: 'maximumReachableCoverageWithoutMutations.json'.
]

{ #category : 'accessing' }
MutationsExperiment >> minimizedCasesForType: aType [

	^ self
		  execute: [
			  ('Minimizing cases: ' , aType) traceCr.
			  (self baseCasesForType: aType) collect: #minimize ]
		  cached: aType , '_filtered_minimised_cases'
]

{ #category : 'accessing' }
MutationsExperiment >> minimizedCasesForType: aType number: num [

	^ self
		  execute: [
			  ('Minimizing cases: ' , aType) traceCr.
			  (self baseCasesForType: aType number: num) collect: #minimize ]
		  cached: aType , num asString, '_filtered_minimised_cases'
]

{ #category : 'accessing' }
MutationsExperiment >> mutatedCases: cases mutator: mutator prefix: prefix [

	
	^ self
		execute: [ 
			('Mutating cases: ' , prefix , '-' , mutator class name) traceCr.
			runner mutateCases: cases with: { mutator } ]
		cached: prefix , '-' , mutator class name
]

{ #category : 'accessing' }
MutationsExperiment >> mutators [

	^ {
"		  (RASyntacticIsIntMutator new bounds: (OrderedCollection new
				    add: 0;
				    add: SmallInteger maxVal;
				    add: SmallInteger minVal;
				    add: SmallInteger maxVal / 2;
				    add: SmallInteger minVal / 2;
				    yourself))."
		  RAShiftableIntMutator new.
"		  RASyntacticCommutativeOperationMutator new.
		  RASyntacticIsNotIntNotEqualsRandomMutator new.
		  RASyntacticBinaryArithOpWithRandomMutator new.
		  RASyntacticVarGreaterThanMutator new.
		  RASyntacticVarLessThanMutator new.
		  RASyntacticNLessThanVarMutator new.
		  RASyntacticVarGreaterOrEqualsThanVarMutator new.
		  RASyntacticTypeObjectMutator new.
		  RASyntacticVarGreaterThanIntroducingNewVarMutator new"
		}
]

{ #category : 'accessing' }
MutationsExperiment >> nodePathsOf: result [

	^  result at: 'Node paths'
]

{ #category : 'accessing' }
MutationsExperiment >> primitivesWithAllMutations [
	
	| primitiveCases |
	
	primitiveCases := self allPossibleCasesFor: 'primitives'.

	RAConcolicRunner runAndMeasure: primitiveCases with: RAPrimitiveAutoTest new at: 'primitivesWithAllMutations.json'.
]

{ #category : 'accessing' }
MutationsExperiment >> run: aType cases: cases prefix: prefix [
	"Test cases"

	| case |
	('Running: ' , prefix , ' ' , aType) traceCr.

	case := aType = #bytecodes
		        ifTrue: [ RABytecodeAutoTest new ]
		        ifFalse: [ RAPrimitiveAutoTest new ].
	"Baselines"
	RAConcolicRunner
		runAndMeasure: cases
		with: case
		at: aType , '_', prefix , '_run' , '.json'
]

{ #category : 'accessing' }
MutationsExperiment >> runBytecode: bytecode [
	
	^ RAConcolicRunner runAndMeasure: (self allPossibleCasesFor: #bytecodes number: bytecode) with: RAPrimitiveAutoTest new at: 'runBytecode', bytecode asString, '.json'.
]

{ #category : 'accessing' }
MutationsExperiment >> segmentedMutationExperiment [

" Base report is given from
  primitives.json, bytecodes.json and primitivesAndBytecodes.json
"
	| primitiveCases bytecodeCases basePrimitivesNodePaths baseBytecodesNodePaths primitivesAndBytecodesNodePaths |
	
	basePrimitivesNodePaths := self nodePathsOf: (self jsonFrom: 'primitives.json').
	baseBytecodesNodePaths :=  self nodePathsOf: (self jsonFrom: 'bytecodes.json').
	primitivesAndBytecodesNodePaths := self nodePathsOf: (self jsonFrom: 'primitivesAndBytecodes.json').
	
	primitiveCases := self minimizedCasesForType: #primitives.
	bytecodeCases := self minimizedCasesForType: #bytecodes.
	
	self mutators do: [ :mutator | | mutatedPrimitives primitivesResult mutatedBytecodes bytecodesResult unionNodePaths primitivesNodePaths bytecodesNodePaths |
		mutatedPrimitives := self mutatedCases: primitiveCases mutator: mutator prefix: 'primitives_minimized'.
		mutatedBytecodes := self mutatedCases: bytecodeCases mutator: mutator prefix: 'bytecodes_minimized'.
		primitivesResult := RAConcolicRunner runAndMeasure: mutatedPrimitives with: RAPrimitiveAutoTest new at: mutator className, '_primitives.json'.
		bytecodesResult := RAConcolicRunner runAndMeasure: mutatedBytecodes with: RABytecodeAutoTest new at: mutator className, '_bytecodes.json'.
		
		primitivesNodePaths := self nodePathsOf: primitivesResult.
		bytecodesNodePaths := self nodePathsOf: bytecodesResult.
		
		unionNodePaths := self unionOfNodePaths: primitivesNodePaths with: bytecodesNodePaths.
		
		"Calculate the difference and save it in a file"
		self difference: primitivesNodePaths with: basePrimitivesNodePaths andSaveIn: mutator className, '_difference_primitives_mutated'.
		self difference: bytecodesNodePaths with: baseBytecodesNodePaths andSaveIn: mutator className, '_difference_bytecodes_mutated'.
		self difference: unionNodePaths with: primitivesAndBytecodesNodePaths andSaveIn: mutator className, '_difference_union_mutated'.
	]

]

{ #category : 'accessing' }
MutationsExperiment >> unionOfNodePaths: dict1 with: dict2 [
	
	^ dict2 associations inject: dict1 into: [ :dict :assc |
		dict
			  at: assc key
			  ifPresent: [
				dict at: assc key put: (assc value, (dict at: assc key)) asSet asOrderedCollection  ]
			  ifAbsentPut: [ assc value ].
		dict.
	].
]
