Class {
	#name : 'RADeserializer',
	#superclass : 'Object',
	#category : 'Ranger',
	#package : 'Ranger'
}

{ #category : 'as yet unclassified' }
RADeserializer >> deserializeFile: aFileReference [

	^ self deserializeJSONDictionary:
		  (NeoJSONReader on: aFileReference readStream) next
]

{ #category : 'as yet unclassified' }
RADeserializer >> deserializeJSONDictionary: aDictionary [

	| nodeDict result coveredNodes allMethods collector methodDict methodNames |
	collector := CoverageCollector new.
	methodDict := (aDictionary at: 'Backend') at: 'CogARMCompiler'.

	methodNames := (methodDict at: 'UncoveredMethods')
	               , (methodDict at: 'PartiallyCoveredMethods').
	allMethods := methodNames collect: [ :e |
		              self methodForMethodName: e ].
	collector methods: allMethods.

	result := CoverageResult new.
	result collector: collector.
	nodeDict := aDictionary at: 'Node paths'.
	result methods: (nodeDict keys
			 collect: [ :e | self methodForMethodName: e ]
			 thenSelect: [ :e | e methodClass = CogARMCompiler ]).

	coveredNodes := nodeDict keys flatCollect: [ :e |
		                | method ast |
		                method := self methodForMethodName: e.

		                method methodClass = CogARMCompiler
			                ifTrue: [
				                ast := method ast.
				                (nodeDict at: e) collect: [ :coveredPath |
					                ast childAtPath: coveredPath ] ]
			                ifFalse: [ #(  ) ] ].
	result nodes: coveredNodes.

	^ result
]

{ #category : 'as yet unclassified' }
RADeserializer >> methodForMethodName: methodName [

	| split |
	split := methodName splitOn: '>>'.
	^ (split first asClassInEnvironment: self class environment)
	  >> split second allButFirst asSymbol
]

{ #category : 'as yet unclassified' }
RADeserializer >> showPreviewOfFile: aFileReference [

	(self deserializeFile: aFileReference) showPreview
]
