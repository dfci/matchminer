# MatchMiner
<img src="mman.png"
     alt="MatchMiner man"
     height="100px"
     style="float:right"
/>

Developed at Dana-Farber Cancer Institute (DFCI), MatchMiner is an open source computational platform for matching patient-specific genomic profiles to precision cancer medicine clinical trials.

The input to MatchMiner is two fold: patient-specific genomic and clinical data, and structured eligibility criteria for clinical trials. Patient-specific information includes somatic genomic events, including mutations, copy number alterations, and structural variants. Basic clinical data such as cancer type, age, and sex extracted from the Electronic Medical Record (EMR) are also utilized.

Structured clinical trial eligibility criteria are specified in the Clinical Trial Markup Language (CTML), and allows the specification of genomic and basic clinical criteria described in clinical trial protocol documents.

The MatchMiner platform matches patient-specific genomic events to clinical trials, and makes the results available to trial investigators and clinicians via a web-based platform.

<img src="mm_fig.png"
     alt="MatchMiner modes"
     height="300px"
     align="center"
/>

# Getting Started

To get started with MatchMiner, just run the following command on macOS or Linux:

```
 /bin/bash -c "$(curl -fsSL https://matchminer.org/setup.sh)"
```

This requires bash, cURL, git, docker, and docker-compose.


# Documentation
Documentation for the project can be found here - [Documentation](https://matchminer.gitbook.io/matchminer/)


# Code 
[matchminer-engine-v2](https://github.com/dfci/matchengine-V2) - the core part matching cancer patients to genomically driven clinical trials using Clinical Trial Markup Language (CTML) and patient clinical and genomic data. It utilizes the [matchminer-api](https://github.com/dfci/matchminer-api)  to store source data and matching results and [matchminer-ui](https://github.com/dfci/matchminer-ui) for displaying trial matches and other patient information.
