#!/bin/bash

# CHECK FORMATTING AND LINTING
echo "Running black and pylint..."
black src/


# CHECK STATUS OF REPOSISTORY
echo "Checking status of repository..."
if [ -n "$(git status --porcelain)" ]; then \
		echo "There are uncommitted changes. Commit them first." && exit 1; \
fi


# RUNNING PYLING
echo "Running pylint..."
if pylint src/; then
    echo "Pylint found no problems"
else
    echo "Pylint found problems, clean up before continuing"
    exit 1
fi


# MAKE SURE VERSION IS INCREMENTED
VERSION="$(python -c "import rezzie; print(rezzie.__version__)")"
echo $VERSION
echo "Checking version..."
if [ "$(git tag --sort=-v:refname | head -n1)" = "v${VERSION}" ]; then \
		echo "Version $VERSION has already been tagged. Increment the version number." && exit 1; \
else \
	echo "Version is good to go..."
fi


## BUILD THE PACKAGE ARTIFACTS
rm -rf build dist
python -m build --sdist --wheel


## MAKE THE RELEASE TO GITHUB
echo "Creating release..."
TAG="v${VERSION}"
git tag -a ${TAG} -m "Version ${VERSION}"
git push origin v${VERSION}
RELEASE_BODY=`awk '/## \[Unreleased\]/{flag=1;next}/## \[/{flag=0}flag' CHANGELOG.md`; \
gh release create $TAG --title "Version $VERSION" --notes "$RELEASE_BODY"
gh release upload $TAG dist/rezzie-${VERSION}.tar.gz
gh release upload $TAG dist/rezzie-${VERSION}-py3-none-any.whl

## UPDATE PYPI
echo "Uploading to PyPI..."
twine upload dist/*

## UPDATE CHANGELOG
echo "Updating changelog..."
TODAY=`date +'%Y-%m-%d'`; \
		sed -i '' 's/## \[Unreleased\]/## [Unreleased]\n\n## ['$VERSION'] - '$TODAY'/' CHANGELOG.md
git add CHANGELOG.md
git commit -m "Update changelog for version $VERSION"
git push