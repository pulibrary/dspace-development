# Development Workflow

## DataSpace and the Open Access Repository

When collaborating upon an update or repairing a bug within the code bases for
DataSpace and the OAR, there exists a workflow for deploying, testing, and
releasing updates for the code bases.

For more details on the dev workflow, see [Atmire's DSpace Documentation](https://docs.google.com/document/d/1Q-SsrBPG2Bv526I_6hgjeOb9n3HTRegtyAakPMt-l54/edit#heading=h.fxwqqj3go2dl).

### `DEV` Builds (`dev` Environment)

Currently, there are two `DEV` branches for the DSpace implementations:

- `dataspace-client-DEV`
- `oar-client-DEV`

Both of these are deployed to the `dev` environments:

- [https://dataspace-dev.princeton.edu](https://dataspace-dev.princeton.edu)
- [https://oar-dev.princeton.edu](https://oar-dev.princeton.edu)

From the shell on one's local environment, a typical approach for beginning new sets of improvements is the following:
```bash
ssh -J pulsys@$PROXY dspace@$DEV_HOST
dspace@$DEV_HOST:~$ cd src/
dspace@$DEV_HOST:~$ git checkout dataspace-client-DEV
dspace@$DEV_HOST:~$ git pull --rebase origin dataspace-client-DEV
dspace@$DEV_HOST:~$ git checkout -b dataspace-DEV-my-new-branch
```

At this point, one may then freely modify the files on the server using `vim` or `emacs`. Alternatively, one may also create and push to this branch within their local development environment.

In order to preview the state of a build, one then invokes the following:
```bash
dspace@$DEV_HOST:~$ dsbounce
```

This command triggers a rebuild of the DataSpace or OAR code base on the server environment. One **must** rebuild using `dsbounce` for every change which is introduced into the code base before the updated changes can be viewed in one's web browser.

Once one has finished the changes on the feature branch, one should `git push` to the Atmire GitLab repository. Further one should also perform the following for later testing in the `staging` environment:
```bash
dspace@$DEV_HOST:~$ git checkout -b dataspace-TEST-my-new-branch
```
This should also be pushed using `git push`.

One should then look to offer a `Merge Request` between the new feature branch (`dataspace-DEV-my-new-branch`) and either the base `dataspace-client-DEV` or `oar-client-DEV` branch. After creating the `Merge Request`, another member of the DSpace contributors may be requested to review and merge the `Merge Request`. Note, **please do not create a `Merge Request` for `dataspace-TEST-my-new-branch`**. This must remain unmerged until the next phase of steps.

### `TEST` Builds (`staging` Environment)

Currently, there are two `TEST` branches for the DSpace implementations:

- `dataspace-client-TEST`
- `oar-client-TEST`

Both of these are deployed to the `staging` environments:

- [https://dataspace-staging.princeton.edu](https://dataspace-staging.princeton.edu)
- [https://oar-staging.princeton.edu](https://oar-staging.princeton.edu)

Unlike the `dev` environments, each of these deployments have their databases in parity with those in the production (publicly accessible) environment. Hence, this is more well-suited for testing against entire Collections, Communities, or set of user accounts.

From the shell on one's local environment, one then follows a similar approach to what was undertaken previously:
```bash
ssh -J pulsys@$PROXY dspace@$STAGING_HOST
dspace@$STAGING_HOST:~$ cd src/
dspace@$STAGING_HOST:~$ git checkout dataspace-client-TEST
dspace@$STAGING_HOST:~$ git pull --rebase origin dataspace-client-TEST
dspace@$STAGING_HOST:~$ git checkout dataspace-TEST-my-new-branch
dspace@$STAGING_HOST:~$ git rebase dataspace-client-TEST
```

As the `dataspace-client-DEV`/`oar-client-DEV` and `dataspace-client-TEST`/`oar-client-TEST` branches are kept in synchronization by Atmire on a regular basis, this is perhaps the most straightforward when testing the newly-merged branch within the `staging` environment. One must, as before, again use `dsbounce` to rebuild the code base and view the updates in the browser.

Once all testing has been undertaken in the `staging` environment, one must, as similar to before, perform the following:
```bash
dspace@$STAGING_HOST:~$ git checkout -b dataspace-prod-my-new-branch
```

Following a `git push`, one may then create a new `Merge Request` for `dataspace-TEST-my-new-branch` using `dataspace-client-TEST` as the base branch. One should please request a review from another team member (or, a member of Atmire).

### `prod` Updates (Production Environment)

The production environment contains the publicly-accessible deployments for DSpace:

- `dataspace-prod`
- `oar-prod`

Of which both deployed to these URLs:

- [https://dataspace.princeton.edu](https://dataspace.princeton.edu)
- [https://oar.princeton.edu](https://oar.princeton.edu)

Unlike with the previous phases, one must only `git rebase` and `git push` outside of remote server environments. One may please address this with the following:

```bash
user@localhost:~$ git checkout dataspace-prod
user@localhost:~$ git pull --rebase origin dataspace-prod
user@localhost:~$ git checkout dataspace-prod-my-new-branch
user@localhost:~$ git rebase dataspace-prod
```

Following this, one should issue a `git push`, and create a new `Merge Request` using `dataspace-prod` as the base branch. One should request a review from a member of Atmire for this `Merge Request`. Following the successful merging of this, one must then contact both Atmire and our DevOps Engineer of the Operations Team in order to schedule a production update.

After merging, tag the dataspace-prod branch with the date of the deploy, with syntax: dataspace-production-20201118. If no more work is expected on the branch, delete it locally and on the git server.
