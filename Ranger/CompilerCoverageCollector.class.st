Class {
	#name : 'CompilerCoverageCollector',
	#superclass : 'CoverageCollector',
	#category : 'Ranger',
	#package : 'Ranger'
}

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> compilerMethods [

	^ Cogit methods , SimpleStackBasedCogit methods , StackToRegisterMappingCogit methods
]

{ #category : 'as yet unclassified' }
CompilerCoverageCollector class >> measure: code [

	^ CoverageCollector new methods: self compilerMethods; runOn: code
]

{ #category : 'initialization' }
CompilerCoverageCollector >> initialize [ 

	self methods: Cogit methods , SimpleStackBasedCogit methods , StackToRegisterMappingCogit methods
]
