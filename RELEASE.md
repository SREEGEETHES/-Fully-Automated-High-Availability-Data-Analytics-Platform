# Release schedule

kube-prometheus will follow the Kubernetes release schedule.
For every new Kubernetes release, there will be a corresponding minor release of
kube-prometheus, although it may not be immediate.

We do not guarantee backports from the `main` branch to older release branches.

This differs from the previous release schedule, which was driven by OpenShift releases.

# How to cut a new release

> This guide is strongly based on the [prometheus-operator release
> instructions](https://github.com/prometheus-operator/prometheus-operator/blob/master/RELEASE.md).

## Branch management and versioning strategy

We use [Semantic Versioning](http://semver.org/).

We maintain a separate branch for each minor release, named
`release-<major>.<minor>`, e.g. `release-1.1`, `release-2.0`.

The usual flow is to merge new features, changes and bug fixes into the `main` branch.
The decision to backport bugfixes into release branches is made on a case-by-case basis.
Maintaining the release branches for older minor releases is best-effort.

## Update components version

Every release of kube-prometheus should include the latest versions of each
component. Updating them is automated via a CI job that can be triggered
manually from this
[workflow](https://github.com/prometheus-operator/kube-prometheus/actions/workflows/versions.yaml).

Once the workflow is completed, the prometheus-operator bot will create some
PRs. You should merge the one prefixed by `[bot][main]` if created before
proceeding. If the bot didn't create the PR, it is either because the workflow
failed or because the main branch was already up-to-date.

## Update Kubernetes supported versions

The `main` branch of kube-prometheus should support the last 2 versions of
Kubernetes. We need to make sure that the CI on the main branch is testing the
kube-prometheus configuration against both of these versions by updating the [CI
worklow](.github/workflows/ci.yaml) to include the latest kind version and the
2 latest images versions that are attached to the kind release. Once that is
done, the [compatibility matrix](README.md#compatibility) in
the README should also be updated to reflect the CI changes.

## Create pull request to cut the release

### Pin Jsonnet dependencies

Pin jsonnet dependencies in
[jsonnetfile.json](jsonnet/kube-prometheus/jsonnetfile.json). Each dependency
should be pinned to the latest release branch or if it doesn't have one, pinned
to the latest commit.

### Start with a fresh environment

```bash
make clean
```

### Update Jsonnet dependencies

```bash
make update
```

### Generate manifests

```bash
make generate
```

### Update the compatibility matrix

Update the [compatibility matrix](README.md#compatibility) in
the README, by adding the new release based on the `main` branch compatibility
and removing the oldest release branch to only keep the latest 5 branches in the
matrix.

### Update changelog

Iterate over the PRs that were merged between the latest release of kube-prometheus and the HEAD and add the changelog entries to the [CHANGELOG](CHANGELOG.md).

## Create release branch

Once the PR cutting the release is merged, pull the changes, create a new
release branch named `release-x.y` based on the latest changes and push it to
the upstream repository.

## Create follow-up pull request

### Unpin Jsonnet dependencies

Revert previous changes made when pinning the jsonnet dependencies since we want
the main branch to be in sync with the latest changes of its dependencies.

### Update CI workflow

Update the [versions workflow](.github/workflows/versions.yaml) to include the latest release branch and remove the oldest one to reflect the list of supported releases.

### Update Kubernetes versions used by kubeconform

Update the versions of Kubernetes used when validating manifests with
kubeconform in the [Makefile](Makefile) to align with the compatibility
matrix.
