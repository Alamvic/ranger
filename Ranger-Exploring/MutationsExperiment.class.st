Class {
	#name : 'MutationsExperiment',
	#superclass : 'Object',
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

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
MutationsExperiment >> main [
	"Basic cases"

	| runner bytecodeCases primitiveCases filteredBytecodeCases filteredPrimitiveCases minimizedBytecodeCases minimizedPrimitiveCases bytecodeTestCase primitiveTestCase mutators minimized_mutants original_mutants mutantDifferences |
	runner := RAConcolicRunner new.

	bytecodeCases := runner casesForAllBytecodes.
	"Filtering"
	filteredBytecodeCases := runner getReasonableCases: bytecodeCases.
	"Minimizing"
	minimizedBytecodeCases := filteredBytecodeCases collect: #minimize.
	"Test cases"
	bytecodeTestCase := RABytecodeAutoTest new.
	"Baselines"
	RAConcolicRunner
		runAndMeasure: minimizedBytecodeCases
		with: bytecodeTestCase
		at: 'only_bytecodes.json'.


	primitiveCases := runner casesForAllPrimitives.
	"Filtering"
	filteredPrimitiveCases := runner getReasonableCases: primitiveCases.
	"Minimizing"
	minimizedPrimitiveCases := filteredPrimitiveCases collect: #minimize.
	"Test cases"
	primitiveTestCase := RAPrimitiveAutoTest new.
	"Baselines"
	RAConcolicRunner
		runAndMeasure: minimizedPrimitiveCases
		with: primitiveTestCase
		at: 'only_primitives.json'.

	"Mutators"
	mutators := self mutators.

	mutantDifferences := {
		                     ('bytecodes' -> Dictionary new).
		                     ('primitives' -> Dictionary new) } asDictionary.
	(mutantDifferences at: 'bytecodes') at: 'Base' put: {
			('cases' -> (minimizedBytecodeCases collect: [  :case | case solution path ifNil: [''] ifNotNil: [ case solution path toString ] ])).
			('count' -> minimizedBytecodeCases size)
	} asDictionary.
	(mutantDifferences at: 'primitives') at: 'Base' put: {
			('cases' -> (minimizedPrimitiveCases collect: [  :case | case solution path ifNil: [''] ifNotNil: [ case solution path toString ] ])).
			('count' -> minimizedPrimitiveCases size)
	} asDictionary.

	"Per each baseCases and per each mutator, we generate the report using only that mutator"
	{
		{
			'bytecodes'.
			bytecodeTestCase.
			minimizedBytecodeCases.
			filteredBytecodeCases }.
		{
			'primitives'.
			primitiveTestCase.
			minimizedPrimitiveCases.
			filteredPrimitiveCases } } do: [ :cases |
		mutators do: [ :mutator |
			| mutantClass original_mutants_obj minimized_mutants_obj |
			mutantClass := mutator class asString.
			minimized_mutants := runner
				                     mutateCases: (cases at: 3)
				                     with: { mutator }.
			original_mutants := runner
				                    mutateCases: (cases at: 4)
				                    with: { mutator }.

			original_mutants_obj := {
				                        ('size' -> original_mutants size).
				                        ('path'
				                         ->
				                         (original_mutants collect: [  :case | case solution path ifNil: [''] ifNotNil: [ case solution path toString ] ])) }.
			minimized_mutants_obj := {
				                         ('size' -> minimized_mutants size).
				                         ('path'
				                          ->
				                          (minimized_mutants collect: [  :case | case solution path ifNil: [''] ifNotNil: [ case solution path toString ] ])) }.

			(mutantDifferences at: (cases at: 1)) at: mutantClass put: {
					('original_mutants' -> original_mutants_obj asDictionary).
					('minimized_mutants' -> minimized_mutants_obj asDictionary) }
					asDictionary.
			RAConcolicRunner
				runAndMeasure: minimized_mutants
				with: (cases at: 2)
				at: (cases at: 1) , '_' , mutantClass , '.json' ] ].

	"Make the file that shows the mutant differences between original and filtered cases sizes"
	self class
		makeFileWith: mutantDifferences
		at: 'mutantDifferences.json'
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
