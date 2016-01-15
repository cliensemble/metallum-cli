# Metallum-CLI

A simple gem to search for artists, albums and get more info about any content at [Metal Archives](http://www.metal-archives.com)

## Installation

```
gem install metallum-cli
```

## Usage

This script allows you to perform basic searches at metal-archives.

To show basic infor about a band:

```
metallum-cli BAND
```

To show its discography:

```
metallum-cli BAND --discography all|main|demos|lives|misc
```

For band mambers:

```
metallum-cli BAND --members
```

To show similar bands:

```
metallum-cli BAND --similar
```

To output band's related links: (passing w/o parameters show all links)

```
metallum-cli BAND --links official|merchandise|unofficial|labels|tablatures
```