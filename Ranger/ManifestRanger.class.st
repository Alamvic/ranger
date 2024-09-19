"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestRanger',
	#superclass : 'PackageManifest',
	#category : 'Ranger-Manifest',
	#package : 'Ranger',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestRanger class >> ruleSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#RAAndConstraint #mutate: #false)) #'2024-09-18T17:58:33.904459+02:00') )
]

{ #category : 'code-critics' }
ManifestRanger class >> ruleUnclassifiedMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#RAConstraint #mutate: #false)) #'2024-09-18T17:53:10.304826+02:00') )
]
