Class {
	#name : 'C2CoverageResult',
	#superclass : 'Object',
	#instVars : [
		'collector',
		'methods',
		'nodes'
	],
	#category : 'Collector2',
	#package : 'Collector2'
}

{ #category : 'accessing' }
C2CoverageResult >> collector [

	^ collector
]

{ #category : 'accessing' }
C2CoverageResult >> collector: anObject [

	collector := anObject
]

{ #category : 'accessing' }
C2CoverageResult >> crown [

	| uncoveredMethods uncoveredSelectors crown |
	uncoveredMethods := collector methods difference: methods.
	self assert:
		uncoveredMethods size + methods size = collector methods size.

	uncoveredSelectors := uncoveredMethods
		                      collect: [ :each | each selector ]
		                      as: Set.

	crown := Dictionary new.

	methods do: [ :m | 
		m sendNodes do: [ :n | 
			| selector |
			selector := n selector.
			(uncoveredSelectors includes: selector) ifTrue: [ 
				| c |
				c := crown at: selector ifAbsentPut: [ 
					     | nc |
					     nc := C2Crown new.
					     nc selector: selector.
					     uncoveredMethods
						     select: [ :x | x selector = selector ]
						     thenDo: [ :x | nc callees add: x ].
					     nc ].
				c callers add: n ] ] ].

	^ crown
]

{ #category : 'accessing' }
C2CoverageResult >> hasAllNodesCovered: aMethod [

	aMethod ast nodesDo: [ :node |
		node isSequence ifTrue: [ node hasBeenExecuted ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : 'accessing' }
C2CoverageResult >> methods [

	^ methods
]

{ #category : 'accessing' }
C2CoverageResult >> methods: anObject [

	methods := anObject
]

{ #category : 'accessing' }
C2CoverageResult >> nodes [

	^ nodes
]

{ #category : 'accessing' }
C2CoverageResult >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
C2CoverageResult >> partiallyCoveredMethods [

	^ self methods select: [ :meth | (self hasAllNodesCovered: meth) not ]
]

{ #category : 'accessing' }
C2CoverageResult >> percentage [

	collector nodes isEmpty ifTrue: [ ^ Float nan ].
	^ 100.0 * nodes size / collector nodes size
]

{ #category : 'accessing' }
C2CoverageResult >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' methods: ';
		print: methods size;
		nextPutAll: ' (';
		print: ((100.0 * methods size / collector methods size) rounded) ;
		nextPutAll: '%) nodes: ';
		print: nodes size;
		nextPutAll: ' (';
		print: ((100.0 * nodes size / collector nodes size) rounded) ;
		nextPutAll: '%)'

]

{ #category : 'accessing' }
C2CoverageResult >> showPreview [

    | dr result notExecuted methodsSize |
    dr := DrTests open.
    dr currentPlugin: DTTestCoveragePlugin new.
    result := DTTestCoverageResult new.
    notExecuted := self uncoveredMethods.
    methodsSize := self methods size + self uncoveredMethods size.

    nodes do: [ :markedNode | | theGoodNode |
        theGoodNode := (markedNode methodNode compiledMethod ast childAtPath:
             markedNode path).
        theGoodNode tagExecuted ].

    result
        percent: 1s2 - (notExecuted size / methodsSize asScaledDecimal: 2);
        methodList: notExecuted;
        partiallyCoveredMethods: self partiallyCoveredMethods.

    dr pluginResult: result.
    dr updateWithPluginResult: result
    "result inspect."
]

{ #category : 'accessing' }
C2CoverageResult >> uncoveredMethods [

	^ collector methods \ methods
]

{ #category : 'accessing' }
C2CoverageResult >> uncoveredNodes [

	^ collector nodes \ nodes
]
