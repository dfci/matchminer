# matchminer
Developed at Dana-Farber Cancer Institute (DFCI), MatchMiner is an open source computational platform for matching patient-specific genomic profiles to precision cancer medicine clinical trials.

The input to MatchMiner is two fold: patient-specific genomic and clinical data, and structured eligibility criteria for clinical trials. Patient-specific information includes somatic genomic events, including mutations, copy number alterations, and structural variants. Basic clinical data such as cancer type, age, and sex extracted from the Electronic Medical Record (EMR) are also utilized.

Structured clinical trial eligibility criteria are specified in the Clinical Trial Markup Language (CTML), and allows the specification of genomic and basic clinical criteria described in clinical trial protocol documents.

The MatchMiner platform matches patient-specific genomic events to clinical trials, and makes the results available to trial investigators and clinicians via a web-based platform.

# status
MatchMiner is currently in the progress of being completely made open source. As of 2/4/2019 the core *matchengine*, *api* and *ui* projects are available. None of the code is offered with support or warrenty and currently it is likely not easy to set this system up on your own.

# links
* (matchminer-engine)[https://github.com/dfci/matchminer-engine]
* (matchminer-api)[https://github.com/dfci/matchminer-api]
* (matchminer-ui)[https://github.com/dfci/matchminer-ui]
