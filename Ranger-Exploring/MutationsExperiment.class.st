Class {
	#name : 'MutationsExperiment',
	#superclass : 'Object',
	#instVars : [
		'runner'
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
MutationsExperiment class >> primitivesWithAllMutations [

	self new primitivesWithAllMutations
]

{ #category : 'accessing' }
MutationsExperiment >> allPossibleCasesFor: type [
	
	| cases |
	
	cases := self minimizedCasesForType: type.
	^ cases, (self mutators flatCollect: [ :mutator | self mutatedCases: cases mutator: mutator prefix: type , '_minimized' ]).
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
MutationsExperiment >> bytecodesWithAllMutations [
	
	| primitiveCases |
	
	primitiveCases := self allPossibleCasesFor: 'bytecodes'.
	RAConcolicRunner runAndMeasure: primitiveCases with: RAPrimitiveAutoTest new at: 'bytecodesWithAllMutations.json'.
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
MutationsExperiment >> execute: aBlock cached: aCacheName [
	"aType: { bytecodes, primitives }"

	| cachedFile result |
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
	runner := RAConcolicRunner new
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
MutationsExperiment >> minimizedCasesForType: aType [

	^ self
		  execute: [
			  ('Minimizing cases: ' , aType) traceCr.
			  (self baseCasesForType: aType) collect: #minimize ]
		  cached: aType , '_filtered_minimised_cases'
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
		  (RASyntacticIsIntMutator new bounds: (OrderedCollection new
				    add: 0;
				    add: SmallInteger maxVal;
				    add: SmallInteger minVal;
				    add: SmallInteger maxVal / 2;
				    add: SmallInteger minVal / 2;
				    yourself)).
		  RASyntacticVarGreaterThanMutator new.
		  RASyntacticCommutativeOperationMutator new.
		  RASyntacticVarLessThanMutator new.
		  RASyntacticNLessThanVarMutator new.
		  RASyntacticVarGreaterOrEqualsThanVarMutator new.
		  RASyntacticTypeObjectMutator new.
		  RASyntacticVarGreaterThanIntroducingNewVarMutator new.
		  RASyntacticIsNotIntNotEqualsRandomMutator new.
		  RASyntacticBinaryArithOpWithRandomMutator new }
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
