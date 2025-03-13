Class {
	#name : 'CompilerCoverageCollector',
	#superclass : 'DTCoverageCollector',
	#category : 'Ranger-Exploring-Collector',
	#package : 'Ranger-Exploring',
	#tag : 'Collector'
}

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> backendClasses [

	^ { CogAbstractInstruction }, CogAbstractInstruction withAllSubclasses
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerBackendCoverage: result [

	^ self compilerBackendCoverage: result withSequence: false
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerBackendCoverage: result withSequence: boolean [

	^ self backendClasses inject: Dictionary new into: [ :dict :class |
		dict at: (class name) put: (self coveredMethod: result from: class withSequence: boolean).
		dict
	]
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerCoverage: result [

	| dict coveredNodes |
	coveredNodes := result nodes "flatCollectAsSet: #allSequenceNodes". "<- Tenemos un bug acá? "
	dict := Dictionary new.
	dict at: 'Covered nodes' put: coveredNodes size.
	result collector nodes ifNotNil: [
		dict at: 'Percentage of covered nodes' put: (coveredNodes size * 100) / result collector nodes size
	].
	dict at: 'Frontend' put: (self compilerFrontendCoverage: result).
	dict at: 'Backend' put: (self compilerBackendCoverage: result).
	dict at: 'Node paths' put: (self nodePathsFrom: coveredNodes).
	
	^ dict
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerCoverageDifference: result at: fileName [

	 self writeDict: (self compilerFlatCoverage: result) at: fileName
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerFlatCoverage: result [

	| dict |
	
	dict := Dictionary new.
	dict at: 'Difference covered nodes' put: result nodes size.
	dict at: 'Node paths' put: (self nodePathsFrom: result nodes).
	
	dict at: 'Frontend' put: (self compilerFrontendCoverage: result withSequence: false).
	dict at: 'Backend' put: (self compilerBackendCoverage: result withSequence: false).
	
	^ dict
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerFrontendCoverage: result [

	^ self compilerFrontendCoverage: result withSequence: false
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerFrontendCoverage: result withSequence: boolean [

	^ self frontendClasses inject: Dictionary new into: [ :dict :class |
		dict at: (class name) put: (self coveredMethod: result from: class withSequence: boolean).
		dict
	]
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerMethods [

	^  (
			Cogit methods,
			SimpleStackBasedCogit methods, "Used in the rest of Concolic tests"
			StackToRegisterMappingCogit methods "Used in RAStackToRegisterMappingCogitTest"
		), "Frontend" (
			(CogAbstractInstruction withAllSubclasses flatCollect: #methods) difference: (
				CogOutOfLineLiteralsX64Compiler methods, CogInLineLiteralsARMCompiler methods,
				CogOutOfLineLiteralsARMv8Compiler methods, CogX64Compiler methods,
				CogMIPSELCompiler methods, CogICacheFlushingIA32Compiler methods,
				CogInLineLiteralsX64Compiler methods, CogARMv8Compiler methods
			)
		) "Backend"
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> coveredMethod: result from: aClass [

	^ self coveredMethod: result from: aClass withSequence: true 
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> coveredMethod: result from: aClass withSequence: boolean [

	| totalCoveredMethods unCoveredMethods partiallyCoveredMethods unCoveredPercentage partiallyPercentage classNodes coveredNodes |
	unCoveredMethods := result uncoveredMethods select: [ :m |
		                    m methodClass = aClass ].
	partiallyCoveredMethods := result partiallyCoveredMethods select: [
		                           :m | m methodClass = aClass ].

	totalCoveredMethods := aClass methods difference:
		                       unCoveredMethods
		                       , partiallyCoveredMethods asOrderedCollection.
	unCoveredPercentage := (unCoveredMethods size / aClass methods size
	                        * 100) asFloat.
	partiallyPercentage := (partiallyCoveredMethods size
	                        / aClass methods size * 100) asFloat.

	classNodes := result nodes select: [ :node |
		              node superParent compiledMethod methodClass == aClass ].
	coveredNodes := boolean ifTrue: [ classNodes flatCollectAsSet: #allSequenceNodes ] ifFalse: [ classNodes ].

	^ (OrderedCollection newFromArray: {
			   ('Covered nodes' -> coveredNodes size).
			   ('TotalCoveredPercentage'
			    -> (100 - (unCoveredPercentage + partiallyPercentage))).
			   ('UncoveredPercentage' -> unCoveredPercentage).
			   ('PartiallyCoveredPercentage' -> partiallyPercentage).

			   ('TotalCoveredMethods'
			    -> (totalCoveredMethods collect: #name) sorted).
			   ('UncoveredMethods' -> (unCoveredMethods collect: #name) sorted).
			   ('PartiallyCoveredMethods'
			    -> (partiallyCoveredMethods collect: #name) sorted) })
		  asDictionary
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> frontendClasses [

	^ { Cogit . SimpleStackBasedCogit . StackToRegisterMappingCogit }
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> generateCompilerCoverage: result [
	
	self generateCompilerCoverage: result at: 'CompilerCoverage.json'
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> generateCompilerCoverage: result at: fileName [ 

	self writeDict: (self compilerCoverage: result) at: fileName
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> generateCompilerCoverage: result withFails: fails at: fileName [

	| tempDict jsonString writeStream |
	tempDict := self compilerCoverage: result.

	tempDict at: 'Fails' put: fails.

	jsonString := NeoJSONWriter toStringPretty: tempDict.

	writeStream := fileName asFileReference createFile writeStream.
	writeStream nextPutAll: jsonString.
	writeStream close.
	^ tempDict
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> measure: block [

	^ CoverageCollector new methods: self compilerMethods; runOn: block
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> nodePathsFrom: nodes [

	^ nodes inject: Dictionary new into: [ :dict :node |
		  | methodName path |
		  methodName := node methodNode compiledMethod name.
		  path := node path.
		  dict
			  at: methodName
			  ifPresent: [ (dict at: methodName) add: path ]
			  ifAbsentPut: [ OrderedCollection new add: path; yourself ].
		  dict ]
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> writeDict: tempDict at: fileName [
	
	| jsonString writeStream |

    jsonString := NeoJSONWriter toStringPretty: tempDict.

    writeStream := fileName asFileReference createFile writeStream.
    writeStream nextPutAll: jsonString.
    writeStream close
]

{ #category : 'initialization' }
CompilerCoverageCollector >> initialize [ 

	self methods: self class compilerMethods
]
