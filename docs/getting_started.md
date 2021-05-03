# Getting Started

## Source Code
Currently the source code for both implementations of DataSpace and the Open Access Repository are managed and maintained on the [GitLab repository](https://git.atmire.com/clients/princeton-5). Please note that the DataSpace code base is maintained on the branch `dataspace-prod`, and that the Open Access Repository code base is maintained on the branch `oar-prod`.

## DataSpace

### Server Environments
DataSpace installations are available throughout three server environments. These are currently deployed using the Ubuntu 18.04 LTS operating system:

* [dataspace-dev.princeton.edu](https://dataspace-dev.princeton.edu)
* [dataspace-staging.princeton.edu](https://dataspace-staging.princeton.edu)
* [dataspace.princeton.edu](https://dataspace.princeton.edu)

## Open Access Repository (OAR)

### Server Environments
OAR installations are also deployed on three server environments:

* [oar-dev.princeton.edu](https://oar-dev.princeton.edu)
* [oar-staging.princeton.edu](https://oar-staging.princeton.edu)
* [oar.princeton.edu](https://oar.princeton.edu)

## Repositories

### Actively maintained repositories

- [pulibrary/dspace-cli](https://github.com/pulibrary/dspace-cli): A collection of dataspace-specific administrative jruby scripts inherited from OIT that answer common stakeholder questions.
- [pulibrary/dspace-jruby](https://github.com/pulibrary/dspace-jruby): A jruby wrapper for any DSpace instance. This is used heavily in [pulibrary/dspace-cli](https://github.com/pulibrary/dspace-cli)
- [pulibrary/dspace-python](https://github.com/pulibrary/dspace-python): A collection of dataspace-specific administrative python scripts inherited from OIT that answer common stakeholder questions. It is largely used for bulk ingest and reporting purposes, but with the introduction of [pulibrary/vireo_transformation](https://github.com/pulibrary/vireo_transformation) and PPPL's direct access to dataspace, it may soon no longer be needed.
- [pulibrary/dspace-osti](https://github.com/pulibrary/dspace-osti): An administrative task that scrapes Dataspace and publishes to OSTI. This is a process that needs to be run annually for PPPL to comply with grant requirements.
- [pulibrary/orangetheses](https://github.com/pulibrary/orangetheses/): 
- [PrincetonUniversityLibrary/dspace-smoke-tests](https://github.com/PrincetonUniversityLibrary/dspace-smoke-tests): Automated smoke tests for PUL DSpace instances. Written in Cypress.
- [PrincetonUniversityLibrary/dataspace](https://github.com/PrincetonUniversityLibrary/dataspace): A copy of dataspace in GitHub so that our stakeholders can make PRs to edit XML when necessary.
- [PrincetonUniversityLibrary/thesiscentral-vireo](https://github.com/PrincetonUniversityLibrary/thesiscentral-vireo): Yet more documentation and scripts for ingesting senior theses inherited from OIT. Hopefully deprecated after the creation of [pulibrary/vireo_transformation](https://github.com/pulibrary/vireo_transformation).
- [pulibrary/vireo_transformation](https://github.com/pulibrary/vireo_transformation): A ruby-based solution to the complicated bulk-ingest process of senior theses. Seeking to deprecate the [existing, unreliably python scripts.](https://github.com/pulibrary/dspace-python/tree/main/thesiscentral-vireo/dataspace/python)
