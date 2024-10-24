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
	dict at: 'Frontend' put: (self compilerFrontendCoverage: result).
	dict at: 'Backend' put: (self compilerBackendCoverage: result).

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

	^  Cogit methods,
		SimpleStackBasedCogit methods, "Used in the rest of Concolic tests"
		StackToRegisterMappingCogit methods, "Used in RAStackToRegisterMappingCogitTest"
		
		(CogAbstractInstruction withAllSubclasses flatCollect: #methods) "Backend"
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
CompilerCoverageCollector class >> measure: block [

	^ CoverageCollector new methods: self compilerMethods; runOn: block
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> printCompilerCoverage: result [

    | tempDict jsonString  writeStream fileName |

    fileName := 'CompilerCoverageResult.json'.

    tempDict := self compilerCoverage: result.

    jsonString := NeoJSONWriter toStringPretty: tempDict.

    writeStream := fileName asFileReference createFile writeStream.
    writeStream nextPutAll: jsonString.
    writeStream close
]

{ #category : 'initialization' }
CompilerCoverageCollector >> initialize [ 

	self methods: self class compilerMethods
]
