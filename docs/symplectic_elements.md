# Symplectic Elements

## The Elements REST API

First, please ensure that you have access to the Princeton University VPN by using the `GlobalProtect` client. This can be obtained by following the documentation on https://workcontinuity.princeton.edu/remoteaccess.

Then, please request access to the Elements API password from a member of the Research Data and Scholarship Services (RDSS) team. It is recommended that one set this to a BASH environment variable using the following:
```bash
$ export ELEMENTS_SECRET=$(echo -n "rest:$ELEMENTS_PASSWORD" | base64)
```

One may then proceed by transmitting `GET` requests using then base64-encoded string as an authorization token:

### Production Environment

```bash
# This is the latest release of the API
$ curl -H "Authorization: Basic $ELEMENTS_SECRET" https://oaworkflow.princeton.edu:8091/secure-api/v5.5/users

# This is the legacy API
$ curl -H "Authorization: Basic $ELEMENTS_SECRET" https://oaworkflow.princeton.edu:8091/elements-api/v4.9/users
```

### Quality Assurance (QA) Environment

```bash
# This is the latest release of the API
$ curl -H "Authorization: Basic $ELEMENTS_SECRET" https://oaworkflow-dev.princeton.edu:8091/secure-api/v5.5/users

# This is the legacy API
$ curl -H "Authorization: Basic $ELEMENTS_SECRET" https://oaworkflow-dev.princeton.edu:8091/elements-api/v4.9/users
```

### Symplectic Documentation

For reference, please find the following documentation for the Symplectic Elements REST API at the following:

* [API Administrator Guide](https://support.symplectic.co.uk/support/solutions/articles/6000049959-api-administrator-guide)
* [Manage the Elements API](https://support.symplectic.co.uk/support/solutions/articles/6000049962-manage-the-elements-api)
* [API User Guide](https://support.symplectic.co.uk/support/solutions/articles/6000050010-api-user-guide)
* [API v5.5 Requests and Responses](https://support.symplectic.co.uk/support/solutions/articles/6000170776-api-v5-5-requests-and-responses)
* [API v5.5 Resources and Operations](https://support.symplectic.co.uk/support/solutions/articles/6000170777-api-v5-5-resources-and-operations)
* [API Schemas (in the XML)](https://support.symplectic.co.uk/support/solutions/articles/6000050008-api-schemas)

Should one be required to authenticate with a user name and password for accessing this documentation, please contact a member of the DRDS team for support.

## Troubleshooting

### Network or Server Access
Should one encounter issues related to the ability to access a given service over a TCP port for one of the two servers managed by the Office of Information Technology (OIT), please be aware that there is a specific form which is used to submit firewall rule update requests:

- [Firewall Rule Request](https://princeton.service-now.com/service?id=sc_cat_item&sys_id=c6d0a8591bd66c5098d1217e6e4bcbbd)

Otherwise, should there be any general questions regarding the ability to request server access, please submit the enquiry using:

- [Get Help](https://princeton.service-now.com/service?id=csm_sc_cat_item&sys_id=588cfb664fcd124022a859dd0210c7ca)

