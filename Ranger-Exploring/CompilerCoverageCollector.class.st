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

	^ self backendClasses inject: Dictionary new into: [ :dict :class |
		dict at: (class name) put: (self coveredMethod: result from: class).
		dict
	]
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerCoverage: result [

	| dict |
	dict := Dictionary new.
	dict at: 'Covered nodes' put: (result nodes size).
	dict at: 'Percentage of covered nodes' put: (result nodes size * 100) / result collector nodes size.
	dict at: 'Frontend' put: (self compilerFrontendCoverage: result).
	dict at: 'Backend' put: (self compilerBackendCoverage: result).
	dict at: 'Node paths' put: (self nodePathsFrom: result).
	
	^ dict
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerFrontendCoverage: result [

	^ self frontendClasses inject: Dictionary new into: [ :dict :class |
		dict at: (class name) put: (self coveredMethod: result from: class).
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

	| totalCoveredMethods unCoveredMethods partiallyCoveredMethods unCoveredPercentage partiallyPercentage |
	
	unCoveredMethods := result uncoveredMethods select: [ :m | m methodClass = aClass ].
	partiallyCoveredMethods := result partiallyCoveredMethods select: [ :m | m methodClass = aClass ].

	totalCoveredMethods := aClass methods difference: (unCoveredMethods , partiallyCoveredMethods).
	unCoveredPercentage := ((unCoveredMethods size / aClass methods size) * 100) asFloat.
	partiallyPercentage := ((partiallyCoveredMethods size / aClass methods size) * 100) asFloat.

	^ (OrderedCollection newFromArray: {
		'TotalCoveredPercentage' -> (100 - (unCoveredPercentage + partiallyPercentage)).
		'UncoveredPercentage' -> unCoveredPercentage.
		'PartiallyCoveredPercentage' -> partiallyPercentage.
		
		'TotalCoveredMethods' -> (totalCoveredMethods collect: #name).
		'UncoveredMethods' -> (unCoveredMethods collect: #name).
		'PartiallyCoveredMethods' -> (partiallyCoveredMethods collect: #name).
	}) asDictionary.
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

    | tempDict jsonString  writeStream |

    tempDict := self compilerCoverage: result.

    jsonString := NeoJSONWriter toStringPretty: tempDict.

    writeStream := fileName asFileReference createFile writeStream.
    writeStream nextPutAll: jsonString.
    writeStream close
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> measure: block [

	^ CoverageCollector new methods: self compilerMethods; runOn: block
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> nodePathsFrom: result [

	^ result nodes inject: Dictionary new into: [ :dict :node |
		  | methodName path |
		  methodName := node methodNode compiledMethod name.
		  path := node path.
		  dict
			  at: methodName
			  ifPresent: [ (dict at: methodName) add: path ]
			  ifAbsentPut: [ OrderedCollection new add: path; yourself ].
		  dict ]
]

{ #category : 'initialization' }
CompilerCoverageCollector >> initialize [ 

	self methods: self class compilerMethods
]
