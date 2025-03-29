Class {
	#name : 'RADeserializer',
	#superclass : 'Object',
	#category : 'Ranger',
	#package : 'Ranger'
}

{ #category : 'as yet unclassified' }
RADeserializer >> deserializeFile: aFileReference [

	^ self deserializeJSONDictionary:
		  (NeoJSONReader on: aFileReference asFileReference readStream) next
]

{ #category : 'as yet unclassified' }
RADeserializer >> deserializeJSONDictionary: aDictionary [

	| nodeDict result coveredNodes allMethods collector methodDict methodNames |
	collector := CoverageCollector new.
	methodDict := (aDictionary at: 'Backend') copyWithAll: (aDictionary at: 'Frontend').
	methodNames := methodDict flatCollect: [ :m |
		((m at: 'UncoveredMethods') copyWithAll: (m at: 'PartiallyCoveredMethods')) copyWithAll: (m at: 'TotalCoveredMethods')].

	allMethods := methodNames collect: [ :e |
		              self methodForMethodName: e ].
	collector methods: allMethods.

	result := CoverageResult new.
	result collector: collector.
	nodeDict := aDictionary at: 'Node paths'.
	result methods: (nodeDict keys
			 collect: [ :e | self methodForMethodName: e ])
			 "thenSelect: [ :e | e methodClass = CogARMCompiler ])".

	coveredNodes := nodeDict keys flatCollect: [ :e |
		                | method ast |
		                method := self methodForMethodName: e.

		                "method methodClass = CogARMCompiler
			                ifTrue: [
				                "ast := method ast.
				                (nodeDict at: e) collect: [ :coveredPath |
					                ast childAtPath: coveredPath ] "]"
			                "ifFalse: [ #(  ) ] "].
	result nodes: coveredNodes.

	^ result
]

{ #category : 'as yet unclassified' }
RADeserializer >> diffNodesBetween: aFile and: anotherFile [

	| file1 file2 additions deletions |
	file1 := self deserializeFile: aFile.
	file2 := self deserializeFile: anotherFile.

	additions := file1 nodes difference: file2 nodes.
	deletions := file2 nodes difference: file1 nodes.

	^ {
		  additions.
		  deletions }
]

{ #category : 'as yet unclassified' }
RADeserializer >> methodForMethodName: methodName [

	^ Object readFrom: methodName
]

{ #category : 'as yet unclassified' }
RADeserializer >> showPreviewOfFile: aFileReference [

	(self deserializeFile: aFileReference) showPreview
]
